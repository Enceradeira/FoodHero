//
// Created by Jorg on 19/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//


#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRepositoryStub.h"


@implementation RestaurantRepositoryStub {
    NSArray *_restaurants;
    SearchException *_exceptionForGetRestaurantFromPlace;
    SearchException *_exceptionForGetPlacesBy;
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

- (NSArray *)getPlacesBy:(CuisineAndOccasion *)cuisine {
    if (_exceptionForGetPlacesBy != nil) {
        @throw _exceptionForGetPlacesBy;
    }

    return _restaurants;
}

- (Restaurant *)getRestaurantFromPlace:(Place *)place currentLocation:(CLLocation *)currentLocation {
    if (_exceptionForGetRestaurantFromPlace != nil) {
        @throw _exceptionForGetRestaurantFromPlace;
    }

    return [[_restaurants linq_where:^(Restaurant *r) {
        return [r.placeId isEqualToString:place.placeId];
    }] linq_firstOrNil];
}

- (double)getMaxDistanceOfPlaces:(CLLocation *)currLocation {
    NSArray *distances = [_restaurants linq_select:^(Place *p) {
        CLLocation *placeLocation = p.location;
        return @([currLocation distanceFromLocation:placeLocation]);
    }];
    NSNumber *result = [[distances linq_sort] linq_lastOrNil];

    return result == nil ? 0 : [result doubleValue];
}

- (BOOL)doRestaurantsHaveDifferentPriceLevels {
    return NO;
}

- (void)simulateNoRestaurantFound:(BOOL)simulateNotRestaurantFound {

}

- (void)simulateNetworkError:(BOOL)simulationEnabled {

}

- (void)simulateSlowResponse:(BOOL)enabled {

}

- (void)injectExceptionForGetRestaurantFromPlace:(SearchException *)exception {
    _exceptionForGetRestaurantFromPlace = exception;
}

- (void)injectExceptionForGetPlacesBy:(SearchException *)exception {
    _exceptionForGetPlacesBy = exception;
}
@end