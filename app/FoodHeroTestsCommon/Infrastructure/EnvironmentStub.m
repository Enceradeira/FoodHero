//
// Created by Jorg on 22/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "EnvironmentStub.h"


@implementation EnvironmentStub {

    NSDate *_now;
}
- (NSDate *)now {
    return _now ? _now : [NSDate date];
}

- (void)injectNow:(NSDate *)date {
    _now = date;
}

@end