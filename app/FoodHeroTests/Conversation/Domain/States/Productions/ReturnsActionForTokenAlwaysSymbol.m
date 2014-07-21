//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ReturnsActionForTokenAlwaysSymbol.h"
#import "TestAction.h"
#import "TokenConsumed.h"
#import "DesignByContractException.h"
#import "StateFinished.h"
#import "TokenNotConsumed.h"


@implementation ReturnsActionForTokenAlwaysSymbol {
    Class _tokenclass;
    id <ConsumeResult> _symbolState;
}

- (instancetype)initWithToken:(Class)tokenclass {
    self = [super init];
    if (self != nil) {
        _tokenclass = tokenclass;
        _symbolState = [TokenNotConsumed new];
    }
    return self;
}


- (id <ConsumeResult>)consume:(ConversationToken *)token {
    if (_symbolState.isStateFinished) {
        @throw [DesignByContractException createWithReason:@"consume can't be called on finished state"];
    }
    if (token.class == _tokenclass) {
        _symbolState = [TokenConsumed create:[TestAction create:self]];
        return _symbolState;
    }
    else {
        if (_symbolState.isTokenConsumed) {
            _symbolState = [StateFinished new];
        }
        return _symbolState;
    }
}

+ (instancetype)create:(Class)token {
    return [[ReturnsActionForTokenAlwaysSymbol alloc] initWithToken:token];
}

@end