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
#import "UGoodBye.h"
#import "AskUserWhatToDoAfterGoodByeAction.h"
#import "AskUserCuisinePreferenceAction.h"
#import "UWantsToSearchForAnotherRestaurant.h"
#import "RestaurantBuilder.h"


@interface ConversationFindingRestaurantFinishedTests : ConversationTestsBase
@end

@implementation ConversationFindingRestaurantFinishedTests {

    Restaurant *_restaurant;
}

- (void)setUp {
    [super setUp];
    _restaurant = [[RestaurantBuilder alloc] build];

    [self.conversation addFHToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];

}

- (void)test_USuggestionFeedbackForLiking_ShouldAskUserWhatToDoNext {
    [self.conversation addFHToken:[USuggestionFeedbackForLiking create:_restaurant text:@"I like it"]];

    [self assertLastStatementIs:@"FH:WhatToDoNextCommentAfterSuccess" userAction:[AskUserWhatToDoNextAction class]];
}

- (void)test_UGoodBye_ShouldTriggerFHGoodByeAfterSuccessAndThenLetTheUserToSearchForAnotherRestaurant {
    [self.conversation addFHToken:[USuggestionFeedbackForLiking create:_restaurant text:@"I like it"]];

    [self.conversation addFHToken:[UGoodBye create:@"Bye, Bye"]];
    [self assertSecondLastStatementIs:@"U:GoodBye" userAction:nil];
    [self assertLastStatementIs:@"FH:GoodByeAfterSuccess" userAction:[AskUserWhatToDoAfterGoodByeAction class]];

    [self.conversation addFHToken:[UWantsToSearchForAnotherRestaurant create:@"Search again, please"]];
    [self assertSecondLastStatementIs:@"U:WantsToSearchForAnotherRestaurant" userAction:nil];
    [self assertLastStatementIs:@"FH:OpeningQuestion" userAction:[AskUserCuisinePreferenceAction class]];

    [self.conversation addFHToken:[UCuisinePreference create:@"norwegian food" text:@"norwegian food"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
}

- (void)test_UWantsToSearchForAnotherRestaurant_ShouldTriggerFHAskCuisinePreferenceAndThenFHSuggestsAnotherRestaurant {
    [self.conversation addFHToken:[USuggestionFeedbackForLiking create:_restaurant text:@"I like it"]];
    [self.conversation addFHToken:[UWantsToSearchForAnotherRestaurant create:@"Again please"]];

    [self assertSecondLastStatementIs:@"U:WantsToSearchForAnotherRestaurant" userAction:nil];
    [self assertLastStatementIs:@"FH:OpeningQuestion" userAction:[AskUserCuisinePreferenceAction class]];

    [self.conversation addFHToken:[UCuisinePreference create:@"norwegian food" text:@"norwegian food"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
}

@end