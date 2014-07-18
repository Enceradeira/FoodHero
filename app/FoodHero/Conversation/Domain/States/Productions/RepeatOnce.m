//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RepeatOnce.h"


@implementation RepeatOnce {
    id <Symbol> _symbol;
    BOOL _isConsuming;
    BOOL _hasConsumed;
}

+ (RepeatOnce *)create:(id <Symbol>)symbol {
    return [[RepeatOnce alloc] initWithSymbol:symbol];
}

- (instancetype)initWithSymbol:(id <Symbol>)symbol {
    self = [super init];
    if (self != nil) {
        _symbol = symbol;
    }
    return self;
}

- (id <ConversationAction>)consume:(ConversationToken *)token {
    if (_hasConsumed) {
        return nil;
    }
    id <ConversationAction> action = [_symbol consume:token];
    if (action != nil) {
        _isConsuming = YES;
    }
    else if (_isConsuming) {
        _hasConsumed = YES;
    }
    return action;
}

@end