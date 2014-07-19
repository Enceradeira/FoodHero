//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtomicSymbol.h"
#import "ConversationSource.h"
#import "RestaurantSearch.h"

@interface UDidResolveProblemWithAccessLocationServiceState : AtomicSymbol
+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch;
@end