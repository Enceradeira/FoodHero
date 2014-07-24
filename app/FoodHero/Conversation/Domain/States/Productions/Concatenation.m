//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Concatenation.h"
#import "StateFinished.h"
#import "DesignByContractException.h"
#import "TokenNotConsumed.h"

@implementation Concatenation {
    NSArray *_symbols;
    NSUInteger _currentSymbolIdx;
    id <ConsumeResult> _symbolState;
}
- (id <ConsumeResult>)consume:(ConversationToken *)token {
    if (_symbolState.isStateFinished) {
        @throw [DesignByContractException createWithReason:@"Consume can't be called on finished result"];
    }
    if (_currentSymbolIdx >= _symbols.count) {
        return [StateFinished new];
    }

    id <Symbol> currSymbol = _symbols[_currentSymbolIdx];
    id <ConsumeResult> result = [currSymbol consume:token];
    if (result.isTokenNotConsumed) {
        if (!_symbolState.isTokenNotConsumed) {
            @throw [DesignByContractException createWithReason:@"Symbol is not allowed to not consume after it has consumed once"];
        }
        return result;
    }
    else if (result.isTokenConsumed) {
        _symbolState = result;
        return result;
    }
    else {
        _currentSymbolIdx++;
        while (_currentSymbolIdx < _symbols.count) {
            // token has finished consuming. We therefore look at next token.
            id <Symbol> nextState = _symbols[_currentSymbolIdx];
            id <ConsumeResult> nextResult = [nextState consume:token];
            if (nextResult.isTokenNotConsumed) {
                @throw [DesignByContractException createWithReason:@"Next symbol in concatenation doesn't consume token. This indicates an invalid state."];
            }
            else if (nextResult.isTokenConsumed) {
                // next symbol was consumed so we stay in 'TokenConsumed'-state
                _symbolState = nextResult;
                return nextResult;
            }
            else {
                // next symbol return 'finished' straight away and was therefore optional (will be ignored)
            }
            _currentSymbolIdx++;
        }
        // there was no next symbol we therefore finish here
        _symbolState = [StateFinished new];
        return _symbolState;
    }
}

- (instancetype)initWithSymbols:(NSArray *)symbols {
    self = [super init];
    if (self != nil) {
        _symbols = symbols;
        _currentSymbolIdx = 0;
        _symbolState = [TokenNotConsumed new];
    }
    return self;
}

+ (Concatenation *)create:(id <RepeatSymbol>)symbol1, ... {
    NSMutableArray *symbols = [NSMutableArray new];

    va_list args;
    va_start(args, symbol1);
    for (id <Symbol> arg = symbol1; arg != nil; arg = va_arg(args, id < Symbol >)) {
        [symbols addObject:arg];
    }

    va_end(args);

    return [[Concatenation alloc] initWithSymbols:symbols];
}

@end