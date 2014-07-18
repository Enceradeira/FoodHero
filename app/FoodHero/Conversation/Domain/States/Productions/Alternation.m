//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Alternation.h"
#import "RepeatSymbol.h"


@implementation Alternation {
    NSArray *_symbols;
    id <RepeatSymbol> _choosenAlternative;
}
- (instancetype)initWithSymbols:(NSArray *)symbols {
    self = [super init];
    if (self != nil) {
        _symbols = symbols;
    }
    return self;
}

- (id <ConversationAction>)consume:(ConversationToken *)token {
    if( _choosenAlternative != nil){
        return [_choosenAlternative consume:token];
    }

    for (NSUInteger i = 0; i < _symbols.count; i++) {
        id <RepeatSymbol> symbol = (id <RepeatSymbol>) _symbols[i];
        id <ConversationAction> action = [symbol consume:token];
        if( action != nil)
        {
            _choosenAlternative = symbol;
            return action;
        }
    }
    return nil;
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

@end