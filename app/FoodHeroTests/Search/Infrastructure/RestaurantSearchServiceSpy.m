//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantSearchServiceSpy.h"


@implementation RestaurantSearchServiceSpy
- (bool)findPlacesWasCalledWithLocation:(CLLocationCoordinate2D)location {
    return self.findPlacesParameter != nil && self.findPlacesParameter.location.latitude == location.latitude && self.findPlacesParameter.location.longitude == location.longitude;
}

- (NSArray *)findPlaces:(RestaurantSearchParams *)parameter {
    _findPlacesParameter = parameter;
    return [NSArray new];
}

- (Restaurant *)getRestaurantForPlace:(Place *)place {
    return nil;
}


@end