//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AlternationBase.h"
#import "Alternation.h"


@implementation Alternation {
    NSArray *_symbols;
}

- (instancetype)initWithSymbols:(NSArray *)symbols {
    self = [super initWithSymbols:symbols];
    if (self) {
        _symbols = symbols;
    }

    return self;
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

- (id <Symbol>)getNextSymbol:(NSUInteger)index {
    return _symbols[index];
}
@end