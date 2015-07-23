//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantSearchServiceStub.h"
#import "RestaurantBuilder.h"

@implementation RestaurantSearchServiceStub {
    SearchException *_exception;
}

- (id)init {
    self = [super init];
    return self;
}

- (Restaurant *)getRestaurantForPlace:(GooglePlace *)place searchLocation:(ResolvedSearchLocation *)location {
    [self simulateException];

    if ([place class] == [Restaurant class]) {
        return (Restaurant *) place;
    }
    return [[[[[RestaurantBuilder alloc] withPlaceId:place.placeId] withLocation:place.location] withCuisineRelevance:place.cuisineRelevance] build];
}

- (void)simulateNetworkError:(BOOL)simulationEnabled {
    if (simulationEnabled) {
        _exception = [SearchException createWithReason:@"simulated search exception"];
    }
    else {
        _exception = nil;
    }
}

- (void)simulateException {
    if (_exception != nil) {
        @throw _exception;
    }
}
@end