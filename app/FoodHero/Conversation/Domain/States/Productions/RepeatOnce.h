//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"
#import "RepeatSymbol.h"

@interface RepeatOnce : NSObject <RepeatSymbol>
+ (RepeatOnce *)create:(id <Symbol>)symbol;

- (instancetype)initWithSymbol:(id <Symbol>)symbol;
@end