//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AlternationBase.h"
#import "DesignByContractException.h"
#import "StateFinished.h"
#import "TokenNotConsumed.h"

@implementation AlternationBase {
    NSArray *_symbols;
    id <Symbol> _choosenAlternative;
    id <ConsumeResult> _symbolState;
}
- (instancetype)initWithSymbols:(NSArray *)symbols {
    self = [super init];
    if (self != nil) {
        _symbols = symbols;
        _symbolState = [TokenNotConsumed new];
    }
    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    if (_symbolState.isStateFinished) {
        @throw [DesignByContractException createWithReason:@"Consume can't be called on finished result"];
    }
    if (_symbols.count == 0) {
        _symbolState = [StateFinished new];
        return _symbolState;
    }

    if (_choosenAlternative != nil) {
        id <ConsumeResult> result = [_choosenAlternative consume:token];
        if (result.isTokenNotConsumed) {
            @throw [DesignByContractException createWithReason:@"Symbol is not allowed to not consume after it has consumed once to become the 'choosen alternative'"];
        }
        else {
            // either the state is 'consumed' or 'finished'
            _symbolState = result;
            return _symbolState;
        }
    }
    else {
        for (NSUInteger i = 0; i < _symbols.count; i++) {
            id <Symbol> symbol = [self getNextSymbol:i];
            id <ConsumeResult> result = [symbol consume:token];
            if (result.isTokenNotConsumed) {
                if (!_symbolState.isTokenNotConsumed) {
                    @throw [DesignByContractException createWithReason:@"Symbol is not allowed to not consume after it has consumed once"];
                }
                // we'll try next alternative
            }
            else {
                // symbol entered state 'consumed' or 'finished'
                _choosenAlternative = symbol;
                _symbolState = result;
                return _symbolState;
            }
        }

        // no alternative entered stated 'consumed' or 'finished', where therefore remain in state 'not consumed'
        return _symbolState;
    }
}

- (id <Symbol>)getNextSymbol:(NSUInteger)index {
    @throw [DesignByContractException createWithReason:@"method must be overriden in subclass"];
}


- (BOOL)isInState:(Class)state {
    if (_symbolState.isTokenConsumed) {
        [_choosenAlternative isInState:state];
    }
    return NO;
}


@end