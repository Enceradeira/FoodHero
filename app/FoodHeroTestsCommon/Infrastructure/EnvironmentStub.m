//
// Created by Jorg on 22/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "EnvironmentStub.h"


@implementation EnvironmentStub {

    NSDate *_now;
}

- (instancetype)init {
    return [super init];
}

- (NSDate *)now {
    return _now ? _now : [NSDate date];
}

- (BOOL)isVersionOrHigher:(unsigned int)major minor:(unsigned int)minor {
    return YES;
}

- (void)injectNow:(NSDate *)date {
    _now = date;
}

@end