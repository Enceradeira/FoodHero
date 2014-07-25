//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "Restaurant.h"
#import "USuggestionFeedback.h"

@interface USuggestionNegativeFeedback : USuggestionFeedback

- (ConversationToken *)foodHeroConfirmationToken;

- (ConversationToken *)getFoodHeroSuggestionWithCommentToken:(Restaurant *)restaurant;
@end