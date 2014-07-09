//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationService.h"


@interface LocationServiceStub : NSObject <LocationService>
- (void)injectLocation:(CLLocationCoordinate2D)location;
@end