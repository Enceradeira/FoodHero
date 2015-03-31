//
// Created by Jorg on 19/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//


#import <ReactiveCocoa.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRepositoryStub.h"
#import "SearchException.h"


@implementation RestaurantRepositoryStub {
    NSArray *_restaurants;
    SearchException *_exception;
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
    [self simulateException];
    return [[_restaurants linq_where:^(Restaurant *r) {
        return [r.placeId isEqualToString:place.placeId];
    }] linq_firstOrNil];
}

- (double)getMaxDistanceOfPlaces:(CLLocation *)currLocation {
      NSArray *distances = [_restaurants linq_select:^(Place *p) {
        CLLocation *placeLocation = p.location;
        return @([currLocation distanceFromLocation:placeLocation]);
    }];
    NSNumber* result = [[distances linq_sort] linq_lastOrNil];

    return result == nil ? 0:[result doubleValue];
}


- (void)simulateException {
    if (_exception != nil) {
        @throw _exception;
    }
}

- (void)injectException:(SearchException *)exception {
    _exception = exception;
}
@end