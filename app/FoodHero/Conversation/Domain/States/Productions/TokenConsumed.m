//
// Created by Jorg on 20/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TokenConsumed.h"


@implementation TokenConsumed {

}
- (BOOL)isStateFinished {
    return NO;
}

- (id)initWithResult:(id <ConversationAction>)result {
    self = [super init];
    if (self != nil) {
        _action = result;
    }
    return self;
}

- (BOOL)isTokenConsumed {
    return YES;
}

- (BOOL)isTokenNotConsumed {
    return NO;
}

+ (instancetype)create:(id <ConversationAction>)result {
    return [[TokenConsumed alloc] initWithResult:result];
}


@end