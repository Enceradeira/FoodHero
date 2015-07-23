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

- (Restaurant *)getRestaurantForPlace:(GooglePlace *)place searchLocation:(ResolvedSearchLocation *)location {
    _nrCallsToGetRestaurantForPlace++;
    return [[RestaurantBuilder alloc] build];
}

- (void)simulateNetworkError:(BOOL)simulationEnabled {

}

- (NSUInteger)nrCallsToGetRestaurantForPlace {
    return _nrCallsToGetRestaurantForPlace;
}

@end