//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtomicSymbol.h"
#import "RestaurantSearch.h"
#import "ConversationSource.h"


@interface UTryAgainNowState : AtomicSymbol
+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch;
@end