//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AtomicSymbol.h"
#import "InvalidConversationStateException.h"
#import "TokenConsumed.h"
#import "TokenNotConsumed.h"
#import "StateFinished.h"


@implementation AtomicSymbol {
    Class _tokenclass;

    id <ConsumeResult> _symbolState;
}

- (instancetype)initWithToken:(Class)tokenclass {
    self = [super init];
    if (self) {
        _tokenclass = tokenclass;
        _symbolState = [TokenNotConsumed new];
    }
    return self;
}


- (id <ConsumeResult>)consume:(ConversationToken *)token {
    if (_symbolState.isStateFinished) {
        @throw [InvalidConversationStateException createWithReason:@"consume can't be called on finished state"];
    }
    else if (_symbolState.isTokenConsumed) {
        // it was consumed before therefore symbol signals it
        _symbolState = [StateFinished new];
        return _symbolState;
    }
    else {
        // token has not been consumed yet
        if ([token isKindOfClass:_tokenclass]) {
            _symbolState = [TokenConsumed create:[self createAction:token]];
            return _symbolState;
        }
        else{
            // symbol state is 'token not consumed'
            return _symbolState;
        }
    }
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}

@end