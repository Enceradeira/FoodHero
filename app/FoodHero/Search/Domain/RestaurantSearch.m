//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "RestaurantSearch.h"
#import "NoRestaurantsFoundError.h"
#import "NSArray+LinqExtensions.h"
#import "SearchException.h"
#import "SearchError.h"
#import "FoodHero-Swift.h"
#import "RestaurantSearchResult.h"

@implementation RestaurantSearch {

    id <IRestaurantRepository> _repository;
    LocationService *_locationService;
    id <ISchedulerFactory> _schedulerFactory;
}

- (instancetype)initWithRestaurantRepository:(id <IRestaurantRepository>)repository locationService:(LocationService *)locationService schedulerFactory:(id <ISchedulerFactory>)schedulerFactory {
    self = [super init];
    if (self != nil) {
        _repository = repository;
        _locationService = locationService;
        _schedulerFactory = schedulerFactory;
    }
    return self;
}

- (double)getMaxDistanceOfPlaces {
    return [_repository getMaxDistanceOfPlaces:_locationService.lastKnownLocation];
}

- (RACSignal *)findBest:(id <ConversationSource>)conversation {
    NSArray *excludedRestaurants = [[conversation.negativeUserFeedback linq_select:^(USuggestionFeedbackParameters *f) {
        return f.restaurant;
    }] linq_concat:conversation.suggestedRestaurantsInCurrentSearch];

    RACSignal *preferenceSignal = [[_locationService.currentLocation take:1] flattenMap:^(CLLocation *location) {
        return [RACSignal return:[conversation currentSearchPreference:[_repository getMaxDistanceOfPlaces:location] currUserLocation:location]];
    }];

    RACSignal *placesSignal = [preferenceSignal flattenMap:^(SearchProfile *searchPreference) {

        NSString *occasion = searchPreference.occasion;
        NSString *cuisine = searchPreference.cuisine;
        NSString *distance = searchPreference.distanceRange.description;
        NSString *price = searchPreference.priceRange.description;
        NSLog([NSString stringWithFormat:@"RestaurantSearch.findBest: occasion=%@ cuisine=%@ distance=%@ price=%@", occasion, cuisine, distance, price]);
        
        
        
        
        return [[[_repository getPlacesBy:[[CuisineAndOccasion alloc] initWithOccasion:searchPreference.occasion cuisine:searchPreference.cuisine]]
                take:1]
                map:^(NSArray *places) {
                    return @[[places linq_where:^(Place *p) {
                        return (BOOL) ![excludedRestaurants linq_any:^(Restaurant *r) {
                            return [p.placeId isEqualToString:r.placeId];
                        }];
                    }], searchPreference];
                }];
    }];

    RACSignal *moreThan0PlacesSignal = [placesSignal
            flattenMap:^(NSArray *placesAndSearchPreference) {
                return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
                    if (((NSArray *) placesAndSearchPreference[0]).count > 0) {
                        [subscriber sendNext:placesAndSearchPreference];
                        [subscriber sendCompleted];
                    }
                    else {
                        [subscriber sendError:[NoRestaurantsFoundError new]];
                    }
                    return nil;
                }];
            }];

    return [[moreThan0PlacesSignal
            flattenMap:^(NSArray *placesAndSearchPreference) {
                return [self getBestPlace:placesAndSearchPreference[0]
                              preferences:placesAndSearchPreference[1]
                      excludedRestaurants:excludedRestaurants];
            }] map:^(NSArray *restaurantAndSearchPreference) {
        return [[RestaurantSearchResult alloc] initWithRestaurant:restaurantAndSearchPreference[0]
                                                     searchParams:restaurantAndSearchPreference[1]];
    }];
};

- (RACSignal *)getBestPlace:(NSArray *)places preferences:(SearchProfile *)preferences excludedRestaurants:(NSArray *)excludedRestaurants {
    return [[[_locationService.currentLocation
            deliverOn:_schedulerFactory.asynchScheduler]
            take:1]
            tryMap:^(CLLocation *location, NSError **error) {
                __block double maxScore = 0;

                NSArray *sortedPlaces = [places linq_sort:^(Place *p) {
                    return @([location distanceFromLocation:p.location]);
                }];


                // determine distance and score
                NSArray *placesAndScore = [sortedPlaces linq_select:^(Place *p) {
                    double distance = [location distanceFromLocation:p.location];
                    double maxDistance = [_repository getMaxDistanceOfPlaces:location];
                    double normalizedDistance = distance == 0 ? 0 : distance / maxDistance;
                    Restaurant *r = nil; //[_repository getRestaurantFromPlace:p];
                    double score = [preferences scorePlace:p normalizedDistance:normalizedDistance restaurant:r];
                    if (score > maxScore) {
                        maxScore = score;
                    }

                    return @[p, @(score), @(distance)];
                }];

                // select all with max-score
                NSArray *bestPlaces = [placesAndScore linq_where:^(NSArray *placeScoreAndDistance) {
                    return (BOOL) ([@(maxScore) compare:(placeScoreAndDistance[1])] == NSOrderedSame);
                }];

                // order all mit max-score by distance
                NSArray *bestPlacesOrderedByDistance = [[bestPlaces linq_sort:^(NSArray *placeScoreAndDistance) {
                    return placeScoreAndDistance[2];
                }] linq_select:^(NSArray *placeScoreAndDistance) {
                    return placeScoreAndDistance[0];
                }];

                // choose nearest that doesn't have same name as previously disliked restaurant
                for (Place *bestPlace in bestPlacesOrderedByDistance) {
                    @try {
                        Restaurant *restaurant = [_repository getRestaurantFromPlace:bestPlace];
                        // NSLog(@"------> %@, %@", restaurant.name, restaurant.vicinity);

                        BOOL dislikedWithSameName = [excludedRestaurants linq_any:^(Restaurant *r) {
                            return [r.name isEqualToString:restaurant.name];
                        }];
                        if(!dislikedWithSameName) {
                            return @[restaurant, preferences];
                        }
                    }
                    @catch (SearchException *e) {
                        *error = [SearchError new];
                        return (NSArray *) nil;
                    }
                }

                // choose nearest
                Place *bestPlace = [bestPlacesOrderedByDistance linq_firstOrNil];
                @try {
                    Restaurant *restaurant = [_repository getRestaurantFromPlace:bestPlace];
                    // NSLog(@"------> %@, %@", restaurant.name, restaurant.vicinity);
                    return @[restaurant, preferences];
                }
                @catch (SearchException *e) {
                    *error = [SearchError new];
                    return (NSArray *) nil;
                }

            }];
}
@end