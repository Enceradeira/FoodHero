//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Alternation.h"
#import "InvalidConversationStateException.h"
#import "StateFinished.h"
#import "TokenNotConsumed.h"
#import "RepeatSymbol.h"

@implementation Alternation {
    NSArray *_symbols;
    id <Symbol> _choosenAlternative;
    id <ConsumeResult> _symbolState;
}

+ (instancetype)create:(id <RepeatSymbol>)symbol1, ... {
    NSMutableArray *symbols = [NSMutableArray new];

    va_list args;
    va_start(args, symbol1);
    for (id <Symbol> arg = symbol1; arg != nil; arg = va_arg(args, id < Symbol >)) {
        [symbols addObject:arg];
    }

    va_end(args);

    return [[Alternation alloc] initWithSymbols:symbols];
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
        @throw [InvalidConversationStateException createWithReason:@"Consume can't be called on finished result"];
    }
    if (_symbols.count == 0) {
        _symbolState = [StateFinished new];
        return _symbolState;
    }

    if (_choosenAlternative != nil) {
        id <ConsumeResult> result = [_choosenAlternative consume:token];
        if (result.isTokenNotConsumed) {
            @throw [InvalidConversationStateException createWithReason:@"Symbol is not allowed to not consume after it has consumed once to become the 'choosen alternative'"];
        }
        else {
            // either the state is 'consumed' or 'finished'
            _symbolState = result;
            return _symbolState;
        }
    }
    else {
        for (NSUInteger i = 0; i < _symbols.count; i++) {
            id <Symbol> symbol = _symbols[i];
            id <ConsumeResult> result = [symbol consume:token];
            if (result.isTokenNotConsumed) {
                if (!_symbolState.isTokenNotConsumed) {
                    @throw [InvalidConversationStateException createWithReason:@"Symbol is not allowed to not consume after it has consumed once"];
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


@end