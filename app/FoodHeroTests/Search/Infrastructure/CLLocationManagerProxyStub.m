//
// Created by Jorg on 11/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "CLLocationManagerProxyStub.h"


@implementation CLLocationManagerProxyStub {
    NSObject <CLLocationManagerDelegate> *_delegate;
    NSArray *_locations;
    CLAuthorizationStatus _authorizationStatus;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        CLLocation *location;

        CLLocationCoordinate2D norwich;
        norwich.latitude = 52.631944; // Maids Head Hotel, Tombland, Norwich
        norwich.longitude = 1.298889;

        location = [[CLLocation new] initWithCoordinate:norwich altitude:50 horizontalAccuracy:50 verticalAccuracy:50 course:0 speed:0 timestamp:[NSDate date]];

        _locations = [NSArray arrayWithObject:location];
        _authorizationStatus = kCLAuthorizationStatusAuthorized;
    }
    return self;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy const)desiredAccuracy {

}

- (void)setDelegate:(NSObject <CLLocationManagerDelegate> *)delegate {
    _delegate = delegate;
}

- (void)startUpdatingLocation {
    if (_delegate != nil && _authorizationStatus == kCLAuthorizationStatusAuthorized && _locations != nil) {
        [_delegate locationManager:nil didUpdateLocations:_locations];
    }
}

- (void)stopUpdatingLocation {

}

- (CLAuthorizationStatus)authorizationStatus {
    return _authorizationStatus;
}

- (void)injectLocations:(NSArray *)locations {
    _locations = locations;
}

- (void)injectLatitude:(double)latitude longitude:(double)longitude {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;

    CLLocation *location = [[CLLocation new] initWithCoordinate:coordinate altitude:50 horizontalAccuracy:50 verticalAccuracy:50 course:0 speed:0 timestamp:[NSDate date]];
    [self injectLocations:[NSArray arrayWithObject:location]];
}

- (void)injectAuthorizationStatus:(CLAuthorizationStatus)status {
    CLAuthorizationStatus oldStatus = _authorizationStatus;
    _authorizationStatus = status;
    if (oldStatus != _authorizationStatus && _delegate != nil) {
        [_delegate locationManager:nil didChangeAuthorizationStatus:_authorizationStatus];
    }

}
@end