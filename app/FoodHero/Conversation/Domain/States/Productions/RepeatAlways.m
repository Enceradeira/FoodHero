//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RepeatAlways.h"
#import "TokenNotConsumed.h"
#import "InvalidConversationStateException.h"
#import "StateFinished.h"


@implementation RepeatAlways {
    id <Symbol> (^_symbolFactory)();

    id <ConsumeResult> _symbolState;
    id <Symbol> _symbol;
}
+ (RepeatAlways *)create:(id <Symbol> (^)())symbolFactory {
    return [[RepeatAlways alloc] initWithSymbol:symbolFactory];
}

- (instancetype)initWithSymbol:(id <Symbol> (^)())symbol {
    self = [super init];
    if (self != nil) {
        _symbolFactory = symbol;
        _symbolState = [TokenNotConsumed new];
    }
    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    if (_symbolState.isStateFinished) {
        @throw [InvalidConversationStateException createWithReason:@"consume can't be called on finished state"];
    }

    if (_symbol == nil) {
        _symbol = _symbolFactory();
    }
    id <ConsumeResult> state = [_symbol consume:token];
    if (state.isTokenNotConsumed) {
        if (!_symbolState.isTokenNotConsumed) {
            @throw [InvalidConversationStateException createWithReason:@"symbol is not allowed to not consume after it has consumed once"];
        }
        // we take that as 0 repetition and go into 'finished' state
        _symbolState = [StateFinished new];
        return _symbolState;
    }
    if (state.isTokenConsumed) {
        _symbolState = state;
        return state;
    }
    else {
        // token has finished consuming. We therefore resets it state an start another repetition 
        _symbol = _symbolFactory();
        id <ConsumeResult> nextState = [_symbol consume:token];
        if (nextState.isTokenNotConsumed) {
            // we can't start another repetition therefore we finish whole repetition
            _symbolState = [StateFinished new];
            return _symbolState;
        }
        else {
            // we entered a new repetition or symbol finished on start of next repetition therefore we finish as well
            _symbolState = nextState;
            return nextState;
        }
    }
}


@end