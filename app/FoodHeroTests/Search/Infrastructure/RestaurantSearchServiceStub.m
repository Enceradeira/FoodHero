//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantSearchServiceStub.h"
#import "DesignByContractException.h"
#import "RestaurantBuilder.h"

@implementation RestaurantSearchServiceStub {
    NSArray *_searchResults;
    BOOL _findReturnsNil;
    NSArray *_ownSearchResults;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        _findReturnsNil = NO;
    }
    return self;
}

- (void)injectFindResults:(NSArray *)restaurants {
    _searchResults = restaurants;
}

- (NSArray *)findPlaces:(RestaurantSearchParams *)parameter {
    return [[self getRestaurants] linq_select:^(Restaurant *r) {
        return [Place createWithPlaceId:r.placeId location:r.location];
    }];
}

- (NSArray *)getRestaurants {
    if (_findReturnsNil) {
        return [NSArray new];
    }
    if (_searchResults != nil) {
        return _searchResults;
    }
    else {
        if (_ownSearchResults == nil) {
            _ownSearchResults = @[[[[[RestaurantBuilder alloc] withName:@"King's Head"] withVicinity:@"Norwich"] build],
                    [[[[RestaurantBuilder alloc] withName:@"Raj Palace"] withVicinity:@"Norwich"] build]];
        }
        return _ownSearchResults;
    }
}

- (Restaurant *)getRestaurantForPlace:(Place *)place {
    NSArray *restaurants = [[self getRestaurants] linq_where:^(Restaurant *r) {
        return [r.placeId isEqualToString:place.placeId];
    }];
    if (restaurants.count == 1) {
        return restaurants[0];
    }
    @throw [DesignByContractException createWithReason:[NSString stringWithFormat:@"Restaurant with placeId='%@' not found", place.placeId]];
}


- (void)injectFindNothing {
    _findReturnsNil = YES;
}

- (void)injectFindSomething {
    _findReturnsNil = NO;
}
@end