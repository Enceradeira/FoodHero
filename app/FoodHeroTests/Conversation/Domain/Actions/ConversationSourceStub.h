//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationSource.h"

@class USuggestionNegativeFeedback;


@interface ConversationSourceStub : NSObject <ConversationSource>
- (void)injectNegativeUserFeedback:(USuggestionNegativeFeedback *)feedback;

- (void)injectCuisine:(NSString *)cuisine;
@end