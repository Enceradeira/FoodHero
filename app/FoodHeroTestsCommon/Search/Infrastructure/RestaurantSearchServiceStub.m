//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantSearchServiceStub.h"
#import "DesignByContractException.h"
#import "RestaurantBuilder.h"
#import "RestaurantsInRadiusAndPriceRange.h"

@implementation RestaurantSearchServiceStub {
    NSArray *_searchResults;
    BOOL _findReturnsNil;
    NSArray *_ownSearchResults;
    SearchException *_exception;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        [self reset];
    }
    return self;
}

- (void)reset {
    _findReturnsNil = NO;
    _searchResults = nil;
    _ownSearchResults = nil;
}

- (void)injectFindResults:(NSArray *)restaurants {
    [self reset];

    // Reads priceLevel from restaurants and constructs RestaurantsInRadiusAndPriceRange-object per price-level
    NSMutableDictionary *priceLevels = [NSMutableDictionary new];
    for (Restaurant *restaurant in restaurants) {
        NSMutableArray *restaurantsOfLevel = priceLevels[@(restaurant.priceLevel)];
        if (restaurantsOfLevel == nil) {
            restaurantsOfLevel = [NSMutableArray new];
            priceLevels[@(restaurant.priceLevel)] = restaurantsOfLevel;
        }
        [restaurantsOfLevel addObject:restaurant];
    }

    NSMutableArray *restaurantsInPriceRange = [NSMutableArray new];
    [priceLevels enumerateKeysAndObjectsUsingBlock:^(NSNumber *level, NSArray *restaurantsOfLevel, BOOL *stop) {
        [restaurantsInPriceRange addObject:[RestaurantsInRadiusAndPriceRange restaurantsInRadius:0 priceLevel:[level unsignedIntegerValue] restaurants:restaurantsOfLevel]];
    }];

    _searchResults = restaurantsInPriceRange;
}

- (void)injectFindResultsWithRadiusAndPriceRange:(NSArray *)restaurantsAtRadius {
    [self reset];
    _searchResults = restaurantsAtRadius;
}

- (NSArray *)findPlaces:(RestaurantSearchParams *)parameter {
    [self simulateException];
    NSArray *result = [self getRestaurantsByRadius:parameter.radius minPriceLevel:parameter.minPriceLevel maxPricelLevel:parameter.maxPriceLevel];
    return [result linq_select:^(Restaurant *r) {
        return [GooglePlace createWithPlaceId:r.placeId location:r.location cuisineRelevance:r.cuisineRelevance];
    }];
}

- (NSArray *)getRestaurantsByRadius:(double)searchRadius minPriceLevel:(NSUInteger)minPriceLevel maxPricelLevel:(NSUInteger)maxPriceLevel {
    if (_findReturnsNil) {
        return [NSArray new];
    }
    if (_searchResults != nil) {
        NSArray *result = [[_searchResults linq_where:^BOOL(RestaurantsInRadiusAndPriceRange *r) {
            return r.radius <= searchRadius && r.priceLevel >= minPriceLevel && r.priceLevel <= maxPriceLevel;
        }] linq_selectMany:^(RestaurantsInRadiusAndPriceRange *r) {
            return r.restaurants;
        }];
        return result == nil ? @[] : result;
    }
    else {
        if (_ownSearchResults == nil) {
            _ownSearchResults = @[[[[[RestaurantBuilder alloc] withName:@"King's Head"] withVicinity:@"Norwich"] build],
                    [[[[RestaurantBuilder alloc] withName:@"Raj Palace"] withVicinity:@"Norwich"] build]];
        }
        return [_ownSearchResults linq_where:^(Restaurant *r) {
            return (BOOL) (r.priceLevel >= minPriceLevel && r.priceLevel <= maxPriceLevel);
        }];
    }
}

- (Restaurant *)getRestaurantForPlace:(GooglePlace *)place currentLocation:(CLLocation *)location {
    [self simulateException];
    if (!_findReturnsNil) {
        NSArray *restaurants;
        if (_searchResults != nil) {
            restaurants = [_searchResults linq_selectMany:^(RestaurantsInRadiusAndPriceRange *r) {
                return r.restaurants;
            }];
        }
        if (_ownSearchResults != nil) {
            restaurants = _ownSearchResults;
        }

        if (restaurants != nil) {
            NSArray *restaurantsWithPlaceId = [restaurants linq_where:^(Restaurant *r) {
                return [r.placeId isEqualToString:place.placeId];
            }];
            if (restaurantsWithPlaceId.count == 1) {
                return restaurantsWithPlaceId[0];
            }
        }
    }
    @throw [SearchException createWithReason:[NSString stringWithFormat:@"Restaurant with placeId='%@' not found", place.placeId]];
}

- (void)simulateNetworkError:(BOOL)simulationEnabled {
    if (simulationEnabled) {
        _exception = [SearchException createWithReason:@"simulated search exception"];
    }
    else {
        _exception = nil;
    }
}


- (void)injectFindNothing {
    [self reset];
    _findReturnsNil = YES;
}

- (void)injectFindSomething {
    [self reset];
    _findReturnsNil = NO;
}

- (void)injectException:(SearchException *)exception {
    _exception = exception;
}

- (void)simulateException {
    if (_exception != nil) {
        @throw _exception;
    }
}
@end