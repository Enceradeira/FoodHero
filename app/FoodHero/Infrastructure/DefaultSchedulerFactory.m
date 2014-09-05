//
// Created by Jorg on 05/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "DefaultSchedulerFactory.h"
#import "RACScheduler.h"


@implementation DefaultSchedulerFactory {

}
- (RACScheduler *)createAsynchScheduler {
    return [RACScheduler scheduler];
}

- (RACScheduler *)createMainThreadScheduler {
    return [RACScheduler mainThreadScheduler];
}

@end