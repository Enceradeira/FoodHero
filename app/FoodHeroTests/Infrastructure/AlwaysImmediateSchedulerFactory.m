//
// Created by Jorg on 05/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AlwaysImmediateSchedulerFactory.h"
#import <ReactiveCocoa.h>


@implementation AlwaysImmediateSchedulerFactory {

}
- (RACScheduler *)createAsynchScheduler {
    return [RACScheduler immediateScheduler];
}

- (RACScheduler *)createMainThreadScheduler {
    return [RACScheduler immediateScheduler];
}

@end