//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "USuggestionFeedbackForLiking.h"
#import "AskUserWhatToDoNextAction.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"

@interface ConversationFindingRestaurantFinishedTests : ConversationTestsBase
@end

@implementation ConversationFindingRestaurantFinishedTests {

    Restaurant *_restaurant;
}

- (void)setUp {
    [super setUp];
    _restaurant = [Restaurant new];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

}

- (void)test_USuggestionFeedback_ShouldAskUserWhatToDoNext {
    [self.conversation addToken:[USuggestionFeedbackForLiking create:_restaurant]];

    [self assertLastStatementIs:@"FH:WhatToDoNext" userAction:[AskUserWhatToDoNextAction class]];
}

@end