//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"
#import "AlternationBase.h"
#import "RepeatSymbol.h"


@interface Alternation : AlternationBase
+ (instancetype)create:(id <RepeatSymbol>)symbol1, ...;
@end