//
// Created by Jorg on 22/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Environment.h"


@implementation Environment {

}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _systemVersion = [[UIDevice currentDevice] systemVersion];
    }
    return self;
}

- (NSDate *)now {
    return [NSDate date];
}

- (BOOL)isVersionOrHigher:(unsigned int)major minor:(unsigned int)minor {
    NSString *version = [NSString stringWithFormat:@"%u.%u", major, minor];
    NSComparisonResult res = [self.systemVersion compare:version options:NSNumericSearch];

    switch (res) {
        case NSOrderedAscending:
            return NO;
        case NSOrderedSame:
            return YES;
        default:
            return YES;
    }
}

@end