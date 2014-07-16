//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationAction.h"
#import "ConversationToken.h"
#import "ConversationState.h"
#import "ActionFeedbackTarget.h"

@class RestaurantSearch;

@interface FHConversationState : ConversationState
- (instancetype)initWithActionFeedback:(id <ActionFeedbackTarget>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch;

+ (instancetype)createWithActionFeedback:(id <ActionFeedbackTarget>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch;

- (ConversationAction *)consume:(ConversationToken *)token;
@end