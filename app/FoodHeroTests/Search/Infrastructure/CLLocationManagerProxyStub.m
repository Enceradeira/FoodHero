//
// Created by Jorg on 11/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "CLLocationManagerProxyStub.h"


@implementation CLLocationManagerProxyStub {
    NSObject <CLLocationManagerDelegate> *_delegate;
    NSArray *_locations;
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
    }
    return self;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy const)desiredAccuracy {

}

- (void)setDelegate:(NSObject <CLLocationManagerDelegate> *)delegate {
    _delegate = delegate;
}

- (void)startUpdatingLocation {
    if (_delegate != nil) {

        [_delegate locationManager:nil didUpdateLocations:_locations];
    }
}

- (void)stopUpdatingLocation {

}

- (void)injectLocations:(NSArray *)locations {
    _locations = locations;
}
@end