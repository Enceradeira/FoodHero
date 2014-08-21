//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantSearchServiceStub.h"
#import "DesignByContractException.h"
#import "RestaurantBuilder.h"
#import "RestaurantsInRadiusAndPriceRange.h"
#import "GoogleRestaurantSearch.h"
#import "PriceRange.h"

@implementation RestaurantSearchServiceStub {
    NSArray *_searchResults;
    BOOL _findReturnsNil;
    NSArray *_ownSearchResults;
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
    _searchResults = @[[RestaurantsInRadiusAndPriceRange restaurantsInRadius:GOOGLE_MAX_SEARCH_RADIUS priceLevel:GOOGLE_PRICE_LEVEL_MIN restaurants:restaurants]];
}

- (void)injectFindResultsWithRadiusAndPriceRange:(NSArray *)restaurantsAtRadius {
    [self reset];
    _searchResults = restaurantsAtRadius;
}

- (NSArray *)findPlaces:(RestaurantSearchParams *)parameter {
    return [[self getRestaurantsByRadius:parameter.radius minPriceLevel:parameter.minPriceLevel maxPricelLevel:parameter.maxPriceLevel] linq_select:^(Restaurant *r) {
        return [GooglePlace createWithPlaceId:r.placeId location:r.location];
    }];
}

- (NSArray *)getRestaurantsByRadius:(double)searchRadius minPriceLevel:(NSUInteger)minPriceLevel maxPricelLevel:(NSUInteger)maxPriceLevel {
    if (_findReturnsNil) {
        return [NSArray new];
    }
    if (_searchResults != nil) {
        NSArray *result = [[[_searchResults linq_where:^BOOL(RestaurantsInRadiusAndPriceRange *r) {
            return r.radius >= searchRadius && r.priceLevel >= minPriceLevel && r.priceLevel <= maxPriceLevel;
        }] linq_select:^(RestaurantsInRadiusAndPriceRange *r) {
            return r.restaurants;
        }] linq_firstOrNil];
        return result == nil ? @[] : result;
    }
    else {
        if (_ownSearchResults == nil) {
            _ownSearchResults = @[[[[[RestaurantBuilder alloc] withName:@"King's Head"] withVicinity:@"Norwich"] build],
                    [[[[RestaurantBuilder alloc] withName:@"Raj Palace"] withVicinity:@"Norwich"] build]];
        }
        return [_ownSearchResults linq_where:^(Restaurant *r) {
            return (BOOL)(r.priceLevel >= minPriceLevel && r.priceLevel <= maxPriceLevel);
        }];
    }
}

- (Restaurant *)getRestaurantForPlace:(GooglePlace *)place {
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
    @throw [DesignByContractException createWithReason:[NSString stringWithFormat:@"Restaurant with placeId='%@' not found", place.placeId]];
}


- (void)injectFindNothing {
    [self reset];
    _findReturnsNil = YES;
}

- (void)injectFindSomething {
    [self reset];
    _findReturnsNil = NO;
}

@end