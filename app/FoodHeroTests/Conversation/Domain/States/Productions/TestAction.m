//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TestAction.h"


@implementation TestAction {
}
- (instancetype)initWithSender:(id <Symbol>)sender {
    self = [super init];
    if (self != nil) {
        _sender = sender;
    }
    return self;
}

+ (instancetype)create:(id <Symbol>)sender {
    return [[TestAction alloc] initWithSender:sender];
}

@end