//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantSearchServiceSpy.h"
#import "RestaurantBuilder.h"


@implementation RestaurantSearchServiceSpy {
    NSUInteger _nrCallsToGetRestaurantForPlace;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _nrCallsToGetRestaurantForPlace = 0;
    }
    return self;
}

- (bool)findPlacesWasCalledWithLocation:(CLLocationCoordinate2D)location {
    return self.findPlacesParameter != nil && self.findPlacesParameter.coordinate.latitude == location.latitude && self.findPlacesParameter.coordinate.longitude == location.longitude;
}

- (NSArray *)findPlaces:(RestaurantSearchParams *)parameter {
    _findPlacesParameter = parameter;
    return [NSArray new];
}

- (Restaurant *)getRestaurantForPlace:(GooglePlace *)place searchLocation:(CLLocation *)location {
    _nrCallsToGetRestaurantForPlace++;
    return [[RestaurantBuilder alloc] build];
}

- (void)simulateNetworkError:(BOOL)simulationEnabled {

}

- (NSUInteger)nrCallsToGetRestaurantForPlace {
    return _nrCallsToGetRestaurantForPlace;
}

@end