//
// Created by Jorg on 19/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//


#import <ReactiveCocoa.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRepositoryStub.h"
#import "Restaurant.h"


@implementation RestaurantRepositoryStub {
    NSArray *_restaurants;
}
- (id)init {
    self = [super init];
    if (self) {
        _restaurants = [NSArray new];
    }
    return self;
}


- (void)injectRestaurants:(NSArray *)restaurants {
    _restaurants = restaurants;
}


- (RACSignal *)getPlacesByCuisine:(NSString *)cuisine {
    return @[_restaurants].rac_sequence.signal;
}

- (Restaurant *)getRestaurantFromPlace:(GooglePlace *)place {
    return [[_restaurants linq_where:^(Restaurant *r) {
        return [r.placeId isEqualToString:place.placeId];
    }] linq_firstOrNil];
}

@end