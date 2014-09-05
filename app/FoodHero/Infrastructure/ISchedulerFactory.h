//
// Created by Jorg on 05/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@protocol ISchedulerFactory <NSObject>
- (RACScheduler *)createAsynchScheduler;

- (RACScheduler *)createMainThreadScheduler;
@end