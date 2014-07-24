//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"
#import "ConversationSource.h"
#import "RestaurantSearch.h"
#import "AtomicSymbol.h"
#import "SearchActionState.h"

@interface UCuisinePreferenceState : SearchActionState

+ (UCuisinePreferenceState *)createWithActionFeedback:(id <ConversationSource>)actionFeedback;
@end