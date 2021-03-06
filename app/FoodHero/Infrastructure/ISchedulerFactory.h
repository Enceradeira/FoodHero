//
// Created by Jorg on 05/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol ISchedulerFactory <NSObject>
- (RACScheduler *)asynchScheduler;

- (RACScheduler *)mainThreadScheduler;
@end