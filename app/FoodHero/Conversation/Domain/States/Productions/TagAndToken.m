//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#include "TagAndToken.h"

@implementation TagAndToken {
}

- (instancetype)initWithTag:(NSString *)tag token:(ConversationToken *)token {
    self = [super init];
    if (self != nil) {
        _tag = tag;
        _token = token;
    }
    return self;
}

+ (instancetype)create:(NSString *)tag token:(ConversationToken *)token {
    return [[TagAndToken alloc] initWithTag:tag token:token];
}


@end