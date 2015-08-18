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
    ResolvedSearchLocation *_lastSearchLocation;
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

    RACSignal *preferenceSignal = [searchLocationSignal flattenMap:^(NSArray *tuple) {
        _lastSearchLocation = [[ResolvedSearchLocation alloc] initWithLocation:tuple[0] description:tuple[1]];
        double maxDistanceOfPlaces = [_repository getMaxDistanceOfPlaces:_lastSearchLocation.location];
        return [RACSignal return:[conversation currentSearchPreference:maxDistanceOfPlaces searchLocation:_lastSearchLocation.location]];
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
                return [self getBestPlace:placesAndSearchPreference[0] preferences:placesAndSearchPreference[1]];
            }] map:^(NSArray *restaurantAndSearchPreference) {
        return [[RestaurantSearchResult alloc] initWithRestaurant:restaurantAndSearchPreference[0]
                                                     searchParams:restaurantAndSearchPreference[1]];
    }];
}

- (CLLocation *)lastSearchLocation {
    return _lastSearchLocation.location;
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
    RACSignal *preferredLocationAndName = [preferredLocationSignal map:^(CLLocation *location) {
        return @[location, searchLocation];
    }];
    RACSignal *usersLocation = [_locationService.currentLocation map:^(CLLocation *location) {
        return @[location, @"" /*searchLocation couldn't be resolved, therefor should not be displayed or used anywhere*/];
    }];
    return [[preferredLocationAndName concat:usersLocation] take:1];
};

- (RACSignal *)getBestPlace:(NSArray *)places preferences:(SearchProfile *)preferences {

    return [[[[RACSignal return:_lastSearchLocation]
            deliverOn:_schedulerFactory.asynchScheduler]
            take:1]
            tryMap:^(ResolvedSearchLocation *locationDesc, NSError **error) {
                NSArray *sortedPlaces = [places linq_sort:^(Place *p) {
                    return @([locationDesc.location distanceFromLocation:p.location]);
                }];

                NSArray *bestPlacesOrderedByDistance = [self scorePlaces:preferences location:locationDesc candidates:sortedPlaces];
                Place *bestPlace = [bestPlacesOrderedByDistance linq_firstOrNil];
                @try {
                    Restaurant *restaurant = [_repository getRestaurantFromPlace:bestPlace searchLocation:locationDesc];
                    // NSLog(@"------> %@, %@", restaurant.name, restaurant.vicinity);
                    return @[restaurant, preferences];
                }
                @catch (SearchException *e) {
                    *error = [SearchError new];
                    return (NSArray *) nil;
                }

            }];
}

- (NSArray *)scorePlaces:(SearchProfile *)preferences location:(ResolvedSearchLocation *)location candidates:(NSArray *)candidates {
    __block double maxScore = 0;
    // determine distance and score
    NSArray *placesAndScore = [candidates linq_select:^(Place *p) {
        double distance = [location.location distanceFromLocation:p.location];
        double maxDistance = [_repository getMaxDistanceOfPlaces:location.location];
        double normalizedDistance = distance == 0 ? 0 : distance / maxDistance;
        Restaurant *r = nil; //[_repository getRestaurantFromPlace:p searchLocation:location];
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