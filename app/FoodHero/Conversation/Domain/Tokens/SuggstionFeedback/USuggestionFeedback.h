//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "Restaurant.h"

@interface USuggestionFeedback : ConversationToken

@property(nonatomic, readonly) Restaurant *restaurant;

- (instancetype)initWithRestaurant:(Restaurant *)restaurant parameter:(NSString *)parameter;

- (ConversationToken *)foodHeroConfirmationToken;

- (ConversationToken *)getFoodHeroSuggestionWithCommentToken:(Restaurant *)restaurant;
@end