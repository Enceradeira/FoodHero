//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "PriceRange.h"

@class SearchProfile;


@protocol ConversationSource <NSObject>
- (void)addFHToken:(ConversationToken *)token;

- (NSArray *)negativeUserFeedback;

- (SearchProfile *)currentSearchPreference;

- (ConversationToken *)lastSuggestionWarning;
@end