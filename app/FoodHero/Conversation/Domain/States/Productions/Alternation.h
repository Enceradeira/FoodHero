//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"
#import "RepeatSymbol.h"


@interface Alternation : NSObject <Symbol>
+ (instancetype)create:(id <RepeatSymbol>)symbol1, ...;

- (instancetype)initWithSymbols:(NSArray *)symbols;
@end