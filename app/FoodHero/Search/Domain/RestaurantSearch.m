//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "RestaurantSearch.h"
#import "NoRestaurantsFoundError.h"
#import "NSArray+LinqExtensions.h"
#import "USuggestionNegativeFeedback.h"
#import "SearchProfil.h"

@implementation RestaurantSearch {

    id <IRestaurantRepository> _repository;
    LocationService *_locationService;
}

- (instancetype)initWithRestaurantRepository:(id <IRestaurantRepository>)repository locationService:(LocationService *)locationService {
    self = [super init];
    if (self != nil) {
        _repository = repository;
        _locationService = locationService;
    }
    return self;
}

- (RACSignal *)findBest:(id <ConversationSource>)conversation {
    SearchProfil *searchPreference = conversation.currentSearchPreference;
    NSArray *excludedPlaceIds = [conversation.negativeUserFeedback linq_select:^(USuggestionNegativeFeedback *f) {
        return f.restaurant.placeId;
    }];

    RACSignal *placesSignal = [[[_repository getPlacesByCuisine:searchPreference.cuisine] take:1]
            map:^(NSArray *places) {
                return [places linq_where:^(Place *p) {
                    return (BOOL) ![excludedPlaceIds linq_any:^(NSString *e) {
                        return [p.placeId isEqualToString:e];
                    }];
                }];
            }];


    RACSignal *moreThan0PlacesSignal = [placesSignal flattenMap:^(NSArray *places) {
        return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
            if (places.count > 0) {
                [subscriber sendNext:places];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:[NoRestaurantsFoundError new]];
            }
            return nil;
        }];
    }];

    return [moreThan0PlacesSignal flattenMap:^(NSArray *places) {
        return [self getBestPlace:places preferences:searchPreference];
    }];
};

- (RACSignal *)getBestPlace:(NSArray *)places preferences:(SearchProfil *)preferences {
    return [[_locationService.currentLocation take:1] map:^(CLLocation *location) {
        __block double maxScore = 0;

        NSArray *sortedPlaces = [places linq_sort:^(Place * p){
            return @([location distanceFromLocation:p.location]);
        }];


        // determine distance and score
        NSArray *placesAndScore = [sortedPlaces linq_select:^(Place *p) {
            double distance = [location distanceFromLocation:p.location];
            Restaurant *r = nil; // [_repository getRestaurantFromPlace:p];
            double score = [preferences scorePlace:p distance:distance restaurant:r];
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

        // choose nearest
        Place *bestPlace = [bestPlacesOrderedByDistance linq_firstOrNil];
        Restaurant *restaurant = [_repository getRestaurantFromPlace:bestPlace];

        NSLog(@"------> %@, %@", restaurant.name, restaurant.vicinity);

        return restaurant;
    }];
}
@end