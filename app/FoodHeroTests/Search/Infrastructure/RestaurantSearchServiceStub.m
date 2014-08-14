//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantSearchServiceStub.h"
#import "DesignByContractException.h"

@implementation RestaurantSearchServiceStub {
    Restaurant *_searchResult;
    BOOL _findReturnsNil;
}

- (id)init {
    self = [super init];
    if (self != nil) {

    }
    return self;
}

- (void)injectFindResult:(Restaurant *)restaurant {
    _searchResult = restaurant;
}

- (NSArray *)findPlaces:(RestaurantSearchParams *)parameter {
    return [[self getRestaurants] linq_select:^(Restaurant *r) {
        return [Place createWithPlaceId:r.placeId location:[CLLocation new]];
    }];
}

- (NSArray *)getRestaurants {
    NSMutableArray *result = [NSMutableArray new];
    if (_findReturnsNil) {
        return [NSArray new];
    }
    if (_searchResult != nil) {
        [result addObject:_searchResult];
    }
    else {
        [result addObject:[Restaurant createWithName:@"King's Head" vicinity:@"Norwich" types:@[@"restaurant"] placeId:@"13331" location:[CLLocation new]]];
        [result addObject:[Restaurant createWithName:@"Raj Palace" vicinity:@"Norwich" types:@[@"restaurant"] placeId:@"33131" location:[CLLocation new]]];
    }
    return result;
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