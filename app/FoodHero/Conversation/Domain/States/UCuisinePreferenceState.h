//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationState.h"
#import "ActionFeedbackTarget.h"
#import "RestaurantSearch.h"

@interface UCuisinePreferenceState : ConversationState

+ (UCuisinePreferenceState *)createWithActionFeedback:(id <ActionFeedbackTarget>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch;
@end