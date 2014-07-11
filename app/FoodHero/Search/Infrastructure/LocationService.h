//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "CLLocationManagerProxy.h"


@interface LocationService : NSObject <CLLocationManagerDelegate>
- (id)initWithLocationManager:(NSObject <CLLocationManagerProxy> *)locationManager;

- (RACSignal *)currentLocation;
@end