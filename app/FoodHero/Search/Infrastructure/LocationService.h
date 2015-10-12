//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CLLocationManagerProxy.h"
#import "ISchedulerFactory.h"


@interface LocationService : NSObject <CLLocationManagerDelegate>
- (id)initWithLocationManager:(NSObject <CLLocationManagerProxy> *)locationManager schedulerFactory:(id <ISchedulerFactory>)schedulerFactory;

- (RACSignal *)currentLocation;

- (CLLocation *)lastKnownLocation;
@end