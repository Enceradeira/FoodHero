//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RepeatAlways.h"


@implementation RepeatAlways {
    id <Symbol> (^_symbolFactory)();
}
+ (RepeatAlways *)create:(id <Symbol> (^)()) symbolFactory{
    return [[RepeatAlways alloc] initWithSymbol:symbolFactory];
}

- (instancetype)initWithSymbol:(id <Symbol> (^)())symbol {
    self = [super init];
    if (self != nil) {
        _symbolFactory = symbol;
    }
    return self;
}

- (id <ConversationAction>)consume:(ConversationToken *)token {
    return [_symbolFactory() consume:token];
}

@end