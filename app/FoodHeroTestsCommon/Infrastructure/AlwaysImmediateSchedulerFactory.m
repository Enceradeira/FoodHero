//
// Created by Jorg on 05/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AlwaysImmediateSchedulerFactory.h"
#import <ReactiveCocoa.h>


@implementation AlwaysImmediateSchedulerFactory {

}
- (RACScheduler *)asynchScheduler {
    return [RACScheduler immediateScheduler];
}

- (RACScheduler *)mainThreadScheduler {
    return [RACScheduler immediateScheduler];
}

@end