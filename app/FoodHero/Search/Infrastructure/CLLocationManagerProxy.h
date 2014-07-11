//
// Created by Jorg on 11/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CLLocationManagerProxy <NSObject>
- (void)setDesiredAccuracy:(CLLocationAccuracy const)desiredAccuracy;

- (void)setDelegate:(NSObject<CLLocationManagerDelegate> *)delegate;

- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;
@end