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
    id <IGeocoderService> _geocoderService;
    CLLocation *_lastSearchLocation;
    NSString *_lastSearchLocationDescription;
}

- (instancetype)initWithRestaurantRepository:(id <IRestaurantRepository>)repository
                             locationService:(LocationService *)locationService
                            schedulerFactory:(id <ISchedulerFactory>)schedulerFactory
                             geocoderService:(id <IGeocoderService>)geocoderService {
    self = [super init];
    if (self != nil) {
        _repository = repository;
        _locationService = locationService;
        _schedulerFactory = schedulerFactory;
        _geocoderService = geocoderService;
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

    NSString *searchLocation = conversation.currentSearchLocation;
    RACSignal *searchLocationSignal = [[self resolvePreferredLocation:searchLocation] deliverOn:[_schedulerFactory asynchScheduler]];

    RACSignal *preferenceSignal = [searchLocationSignal flattenMap:^(CLLocation *location) {
        _lastSearchLocation = location;
        _lastSearchLocationDescription = searchLocation;

        return [RACSignal return:[conversation currentSearchPreference:[_repository getMaxDistanceOfPlaces:_lastSearchLocation] searchLocation:_lastSearchLocation]];
    }];

    RACSignal *placesSignal = [preferenceSignal tryMap:^(SearchProfile *searchPreference, NSError **error) {

        NSString *occasion = searchPreference.occasion;
        NSString *cuisine = searchPreference.cuisine;
        NSString *distance = searchPreference.distanceRange.description;
        NSString *price = searchPreference.priceRange.description;
        NSLog(@"RestaurantSearch.findBest: occasion=%@ cuisine=%@ distance=%@ price=%@", occasion, cuisine, distance, price);

        NSArray *places;
        @try {
            places = [_repository getPlacesBy:[[CuisineAndOccasion alloc] initWithOccasion:searchPreference.occasion
                                                                                   cuisine:searchPreference.cuisine
                                                                                  location:searchPreference.searchLocation]];
        }
        @catch (SearchException *e) {
            *error = [SearchError new];
            return (NSArray *) nil;
        }

        return @[[places linq_where:^(Place *p) {
            return (BOOL) ![excludedRestaurants linq_any:^(Restaurant *r) {
                return [p.placeId isEqualToString:r.placeId];
            }];
        }], searchPreference];
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
}

- (CLLocation *)lastSearchLocation {
    return _lastSearchLocation;
}


- (RACSignal *)resolvePreferredLocation:(NSString *)preferredLocation {
    RACSignal *preferredLocationSignal;

    NSString *searchLocation = preferredLocation;
    if (searchLocation == nil || searchLocation.length == 0) {
        preferredLocationSignal = [RACSignal empty];
    }
    else {
        preferredLocationSignal = [[[_geocoderService geocodeAddressString:searchLocation] take:1] filter:^(CLLocation *location) {
            return (BOOL) (location != nil);
        }];
    }

    // return preferredLocation is it was resolved, other return currentLocation
    return [[preferredLocationSignal concat:_locationService.currentLocation] take:1];
};

- (RACSignal *)getBestPlace:(NSArray *)places preferences:(SearchProfile *)preferences excludedRestaurants:(NSArray *)excludedRestaurants {

    return [[[[RACSignal return:_lastSearchLocation]
            deliverOn:_schedulerFactory.asynchScheduler]
            take:1]
            tryMap:^(CLLocation *location, NSError **error) {
                NSArray *sortedPlaces = [places linq_sort:^(Place *p) {
                    return @([location distanceFromLocation:p.location]);
                }];

                // find best and try to remove restaurant with same name as disliked places
                NSMutableArray *candidates = [NSMutableArray arrayWithArray:sortedPlaces];
                while (candidates.count > 0) {

                    NSArray *bestPlacesOrderedByDistance = [self scorePlaces:preferences location:location candidates:candidates];

                    // choose nearest that doesn't have same name as previously disliked restaurant
                    for (Place *bestPlace in bestPlacesOrderedByDistance) {
                        @try {
                            Restaurant *restaurant = [_repository getRestaurantFromPlace:bestPlace searchLocation:location searchLocationDescription:_lastSearchLocationDescription];
                            // NSLog(@"------> %@, %@", restaurant.name, restaurant.vicinity);

                            BOOL dislikedWithSameName = [excludedRestaurants linq_any:^(Restaurant *r) {
                                return [r.name isEqualToString:restaurant.name];
                            }];
                            if (!dislikedWithSameName) {
                                return @[restaurant, preferences];
                            }
                            else {
                                [candidates removeObject:bestPlace];
                                break;
                            }
                        }
                        @catch (SearchException *e) {
                            *error = [SearchError new];
                            return (NSArray *) nil;
                        }
                    }
                }

                // no restaurant was found above; we now score again and return even restaurant has same name as disliked place
                NSArray *bestPlacesOrderedByDistance = [self scorePlaces:preferences location:location candidates:sortedPlaces];
                Place *bestPlace = [bestPlacesOrderedByDistance linq_firstOrNil];
                @try {
                    Restaurant *restaurant = [_repository getRestaurantFromPlace:bestPlace searchLocation:location searchLocationDescription:_lastSearchLocationDescription];
                    // NSLog(@"------> %@, %@", restaurant.name, restaurant.vicinity);
                    return @[restaurant, preferences];
                }
                @catch (SearchException *e) {
                    *error = [SearchError new];
                    return (NSArray *) nil;
                }

            }];
}

- (NSArray *)scorePlaces:(SearchProfile *)preferences location:(CLLocation *)location candidates:(NSArray *)candidates {
    __block double maxScore = 0;
    // determine distance and score
    NSArray *placesAndScore = [candidates linq_select:^(Place *p) {
        double distance = [location distanceFromLocation:p.location];
        double maxDistance = [_repository getMaxDistanceOfPlaces:location];
        double normalizedDistance = distance == 0 ? 0 : distance / maxDistance;
        Restaurant *r = nil;//[_repository getRestaurantFromPlace:p];
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
    return bestPlacesOrderedByDistance;
}
@end