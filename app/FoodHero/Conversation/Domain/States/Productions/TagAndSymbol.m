//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RandomAlternation.h"
#include "TagAndSymbol.h"

@implementation TagAndSymbol {
}

- (instancetype)initWithTag:(NSString *)tag symbol:(id <RepeatSymbol>)symbol {
    self = [super init];
    if (self != nil) {
        _tag = tag;
        _symbol = symbol;

    }
    return self;
}

@end