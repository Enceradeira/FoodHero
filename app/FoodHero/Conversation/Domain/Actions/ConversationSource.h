//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "PriceRange.h"
#import "SearchProfile.h"

@class ConversationParameters;

@protocol ConversationSource <NSObject>
- (void)addFHToken:(ConversationToken *)token;

- (NSArray *)negativeUserFeedback;

- (SearchProfile *)currentSearchPreference;

- (ConversationParameters *)lastSuggestionWarning;
@end