//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RepeatOnce.h"
#import "DesignByContractException.h"
#import "TokenNotConsumed.h"


@implementation RepeatOnce {
    id <Symbol> _symbol;
    id <ConsumeResult> _symbolState;
}

+ (RepeatOnce *)create:(id <Symbol>)symbol {
    return [[RepeatOnce alloc] initWithSymbol:symbol];
}

- (instancetype)initWithSymbol:(id <Symbol>)symbol {
    self = [super init];
    if (self != nil) {
        _symbol = symbol;
        _symbolState = [TokenNotConsumed new];
    }
    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    if (_symbolState.isStateFinished) {
        @throw [DesignByContractException createWithReason:@"consume can't be called on finished state"];
    }
    id <ConsumeResult> result = [_symbol consume:token];
    if (result.isTokenNotConsumed) {
        if (!_symbolState.isTokenNotConsumed) {
            @throw [DesignByContractException createWithReason:@"symbol is not allowed to not consume after it has consumed once"];
        }
        return result;
    }
    else if (result.isTokenConsumed) {
        _symbolState = result;
        return result;
    }
    else {
        _symbolState = result;
        return result;
    }
}

- (BOOL)isInState:(Class)state {
    if (_symbolState.isStateFinished) {
        return NO;
    }
    return [_symbol isInState:state];
}


@end