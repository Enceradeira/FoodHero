//
// Created by Jorg on 11/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CLLocationManagerImpl.h"
#import "IosLocationService.h"


@implementation CLLocationManagerImpl {
    CLLocationManager *_locationManager;
}

- (id)initWithLocationManager:(CLLocationManager *)locationManager {
    self = [super init];
    if (self != nil) {
        _locationManager = locationManager;
    }
    return self;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy const)desiredAccuracy {
    [_locationManager setDesiredAccuracy:desiredAccuracy];
}

- (void)setDelegate:(NSObject<CLLocationManagerDelegate> *)delegate {
    [_locationManager setDelegate:delegate];
}

- (void)startUpdatingLocation {
    [_locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    [_locationManager stopUpdatingLocation];
}

@end