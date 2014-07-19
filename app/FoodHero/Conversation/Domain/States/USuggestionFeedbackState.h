//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"
#import "AtomicSymbol.h"
#import "RestaurantSearch.h"
#import "ConversationSource.h"

@interface USuggestionFeedbackState : AtomicSymbol
+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch;
@end