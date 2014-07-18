//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Concatenation.h"
#import "DesignByContractException.h"
#import "NSArray+LinqExtensions.h"

@interface SymbolState : NSObject
@property(nonatomic) int count;
@property(nonatomic, readonly) id <RepeatSymbol> symbol;
@end

@implementation SymbolState
- (instancetype)initWithSymbol:(id <RepeatSymbol>)symbol {
    self = [super init];
    if (self != nil) {
        _symbol = symbol;
        _count = 0;
    }
    return self;
}

+ (instancetype)create:(id <RepeatSymbol>)symbol {
    return [[SymbolState alloc] initWithSymbol:symbol];
}
@end

@implementation Concatenation {

    NSArray *_symbolStates;
}
- (id <ConversationAction>)consume:(ConversationToken *)token {
    // determine current state
    SymbolState *firstSymbol = [_symbolStates linq_firstOrNil];
    if (firstSymbol == nil) {
        @throw [DesignByContractException createWithReason:@"concatenation is empty"];
    }
    SymbolState *currentSymbol = [[_symbolStates
            linq_where:^(SymbolState *s){
                return (BOOL) (s.count > 0);
            }]
            linq_lastOrNil];

    if (currentSymbol == nil) {
        currentSymbol = firstSymbol;
    }

    // try current symbol
    id <ConversationAction> action = [currentSymbol.symbol consume:token];
    currentSymbol.count++;
    if (action != nil) {
        return action;
    }
    /*
    else if (firstSymbol.count == 0) {
        return nil; // state is not entered, token is not consumed
    } */

    // try next symbol
    SymbolState *nextSymbol = [[_symbolStates
            linq_where:^(SymbolState *s){
                return (BOOL) (s.count == 0);
            }]
            linq_firstOrNil];
    if (nextSymbol == nil) {
        return nil; // all symbols have been consumed
    }
    id <ConversationAction> nextAction = [nextSymbol.symbol consume:token];
    nextSymbol.count++;
    if (nextAction != nil) {
        return nextAction;
    }

    return nil;
    // @throw [DesignByContractException createWithReason:@"next symbol didn't consume in concatenation. That indicates an invalid state."];
}

- (instancetype)initWithSymbols:(NSArray *)symbolStates {
    self = [super init];
    if (self != nil) {
        _symbolStates = symbolStates;
    }
    return self;
}

+ (Concatenation *)create:(id <RepeatSymbol>)symbol1, ... {
    NSMutableArray *symbols = [NSMutableArray new];

    va_list args;
    va_start(args, symbol1);
    for (id <Symbol> arg = symbol1; arg != nil; arg = va_arg(args, id < Symbol >)) {
        [symbols addObject:[SymbolState create:arg]];
    }

    va_end(args);

    return [[Concatenation alloc] initWithSymbols:symbols];
}

@end