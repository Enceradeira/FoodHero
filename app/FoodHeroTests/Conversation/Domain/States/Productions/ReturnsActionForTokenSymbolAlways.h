//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "Symbol.h"
#import "AtomicSymbol.h"

@interface ReturnsActionForTokenSymbolAlways : NSObject<Symbol>
+(instancetype)create:(Class)token;
@end