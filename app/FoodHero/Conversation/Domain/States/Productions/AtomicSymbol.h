//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"


@interface AtomicSymbol : NSObject<Symbol>
- (id)initWithToken:(Class)tokenclass;

- (id <ConversationAction>)createAction:(ConversationToken *)token;
@end