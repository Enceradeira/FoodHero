//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRepository.h"
#import "SearchException.h"
#import "FoodHero-Swift.h"

@implementation RestaurantRepository {
    id <RestaurantSearchService> _searchService;
    CLLocation *_locationAtMomentOfCaching;
    CuisineAndOccasion *_paramsAtMomentOfCaching;
    NSArray *_placesCached;
    NSMutableDictionary *_restaurantsCached;
    BOOL _isSimulatingNoRestaurantFound;
    NSTimeInterval _responseDelay;
    id <IPlacesAPI> _placesAPI;
}
- (instancetype)initWithSearchService:(id <RestaurantSearchService>)searchService placesAPI:(id <IPlacesAPI>)placesAPI {
    self = [super init];
    if (self != nil) {
        _searchService = searchService;
        _placesAPI = placesAPI;
        _restaurantsCached = [NSMutableDictionary new];
        _isSimulatingNoRestaurantFound = NO;
        _responseDelay = 0;
    }
    return self;
}

- (NSArray *)getPlacesBy:(CuisineAndOccasion *)parameter {

    @synchronized (self) {
        CLLocation *location = parameter.location;

        BOOL isCuisineOrOccasionStillSame =
                [parameter.cuisine isEqualToString:_paramsAtMomentOfCaching.cuisine] &&
                        [parameter.occasion isEqualToString:_paramsAtMomentOfCaching.occasion];

        BOOL isLocationStillTheSame = [location distanceFromLocation:_locationAtMomentOfCaching] < 100;

        if (_isSimulatingNoRestaurantFound) {
            return @[];
        }

        if (_placesCached == nil || !isCuisineOrOccasionStillSame || !isLocationStillTheSame) {
            _locationAtMomentOfCaching = location;
            _paramsAtMomentOfCaching = parameter;

            [self logGAIEventAction:[GAIActions searchParamsOccasion] label:parameter.occasion];
            [self logGAIEventAction:[GAIActions searchParamsCusine] label:parameter.cuisine];

            id result = [_placesAPI findPlaces:parameter.cuisine occasion:parameter.occasion location:parameter.location];

            if ([result isKindOfClass:[NSError class]]) {
                _placesCached = nil; // return nil; therefor error will be returned
                NSError *error = result;
                @throw [SearchException createWithReason:[error description]];
            }
            else {
                _placesCached = result;
            }
        }
        // sleep a bit to test asynchronous behaviour of the app
        [NSThread sleepForTimeInterval:_responseDelay];
        // yields all places as first element in sequence
        return _placesCached;
    }
}

- (Restaurant *)getRestaurantFromPlace:(Place *)place searchLocation:(ResolvedSearchLocation *)searchLocation {
    @synchronized (self) {
        Restaurant *restaurant = _restaurantsCached[place.placeId];
        if (restaurant == nil) {
            restaurant = [_searchService getRestaurantForPlace:place searchLocation:searchLocation];
            _restaurantsCached[place.placeId] = restaurant;
        }
        return restaurant;
    }
}

- (BOOL)doRestaurantsHaveDifferentPriceLevels {
    @synchronized (self) {
        if (_placesCached == nil || _placesCached.count == 0) {
            return NO;
        }
        NSUInteger firstPriceLevel = ((Place *) _placesCached[0]).priceLevel;
        return [_placesCached linq_any:^(Place *p) {
            return (BOOL) (p.priceLevel != firstPriceLevel);
        }];
    }
}

- (void)simulateNoRestaurantFound:(BOOL)simulateNotRestaurantFound {
    _isSimulatingNoRestaurantFound = simulateNotRestaurantFound;
}

- (void)simulateNetworkError:(BOOL)simulationEnabled {
    _placesCached = nil;
    [_searchService simulateNetworkError:simulationEnabled];
}

- (void)simulateSlowResponse:(BOOL)enabled {
    _responseDelay = enabled ? 5 : 0;
}

- (double)getMaxDistanceOfPlaces:(CLLocation *)currLocation {
    @synchronized (self) {
        if (_placesCached == nil) {
            return 0;
        }
        NSArray *distances = [_placesCached linq_select:^(Place *p) {
            CLLocation *placeLocation = p.location;
            return @([currLocation distanceFromLocation:placeLocation]);
        }];
        NSNumber *result = [[distances linq_sort] linq_lastOrNil];

        return result == nil ? 0 : [result doubleValue];
    }
}

- (void)logGAIEventAction:(NSString *)action label:(NSString *)label {
    [GAIService logEventWithCategory:[GAICategories searchParams] action:action label:label value:0];
};


@end