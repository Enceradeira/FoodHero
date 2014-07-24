//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"
#import "AtomicSymbol.h"
#import "RestaurantSearch.h"
#import "ConversationSource.h"
#import "SearchActionState.h"

@interface USuggestionFeedbackState : SearchActionState
+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback;
@end