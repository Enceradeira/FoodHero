//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"
#import "ConversationSource.h"
#import "RestaurantSearch.h"
#import "AtomicSymbol.h"

@interface SearchActionState : AtomicSymbol

- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback tokenclass:(Class)tokenclass;

@end