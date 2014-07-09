//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantSearchServiceSpy.h"


@implementation RestaurantSearchServiceSpy {

    RestaurantSearchParams *_parameter;
}
- (bool)findWasCalledWithLocation:(CLLocationCoordinate2D)location {
    return _parameter != nil && _parameter.location.latitude == location.latitude && _parameter.location.longitude == location.longitude;
}

- (NSArray *)find:(RestaurantSearchParams *)parameter {
    _parameter = parameter;
    return [NSArray new];
}


@end