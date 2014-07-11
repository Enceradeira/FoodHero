//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationService.h"
#import "CLLocationManagerProxy.h"


@interface IosLocationService : NSObject <LocationService, CLLocationManagerDelegate>
- (id)initWithLocationManager:(NSObject <CLLocationManagerProxy> *)locationManager;
@end