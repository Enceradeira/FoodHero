//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class RACSignal;

@protocol LocationService <NSObject>
- (CLLocationCoordinate2D)getCurrentLocation;
- (RACSignal *)currentLocation;
@end