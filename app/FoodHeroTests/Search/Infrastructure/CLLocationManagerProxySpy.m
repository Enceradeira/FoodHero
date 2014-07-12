//
// Created by Jorg on 11/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "CLLocationManagerProxySpy.h"


@implementation CLLocationManagerProxySpy {

    NSObject <CLLocationManagerDelegate> *_delegate;
}
- (void)setDesiredAccuracy:(CLLocationAccuracy const)desiredAccuracy {

}

- (void)setDelegate:(NSObject <CLLocationManagerDelegate> *)delegate {
    _delegate = delegate;
}

- (void)startUpdatingLocation {
    _nrCallsForStartUpdatingLocation++;
    if (_delegate != nil) {

        CLLocationCoordinate2D norwich;
        norwich.latitude = 52.631944; // Maids Head Hotel, Tombland, Norwich
        norwich.longitude = 1.298889;

        CLLocation *location = [[CLLocation new] initWithCoordinate:norwich altitude:50 horizontalAccuracy:50 verticalAccuracy:50 course:0 speed:0 timestamp:[NSDate date]];

        NSArray *locations = [NSArray arrayWithObject:location];
        [_delegate locationManager:nil didUpdateLocations:locations];
    }
}

- (void)stopUpdatingLocation {
    _nrCallsForStopUpdatingLocation++;
}

- (CLAuthorizationStatus)authorizationStatus {
    return kCLAuthorizationStatusAuthorized;
}


@end