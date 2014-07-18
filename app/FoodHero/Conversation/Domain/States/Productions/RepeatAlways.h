//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"
#import "RepeatSymbol.h"


@interface RepeatAlways : NSObject <RepeatSymbol>
+ (RepeatAlways *)create:(id <Symbol> (^)())symbolFactory;

- (instancetype)initWithSymbol:(id <Symbol> (^)())symbol;
@end