//
// Created by Jorg on 05/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "DefaultSchedulerFactory.h"


@implementation DefaultSchedulerFactory {

}
- (RACScheduler *)asynchScheduler {
    return [RACScheduler scheduler];
}

- (RACScheduler *)mainThreadScheduler {
    return [RACScheduler mainThreadScheduler];
}

@end