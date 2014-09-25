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

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

}

- (void)test_USuggestionFeedbackForLiking_ShouldAskUserWhatToDoNext {
    [self.conversation addToken:[USuggestionFeedbackForLiking create:_restaurant]];

    [self assertLastStatementIs:@"FH:WhatToDoNextAfterSuccess" userAction:[AskUserWhatToDoNextAction class]];
}

- (void)test_UGoodBye_ShouldTriggerFHGoodByeAfterSuccessAndThenLetTheUserToSearchForAnotherRestaurant {
    [self.conversation addToken:[USuggestionFeedbackForLiking create:_restaurant]];

    [self.conversation addToken:[UGoodBye new]];
    [self assertSecondLastStatementIs:@"U:GoodBye" userAction:nil];
    [self assertLastStatementIs:@"FH:GoodByeAfterSuccess" userAction:[AskUserWhatToDoAfterGoodByeAction class]];

    [self.conversation addToken:[UWantsToSearchForAnotherRestaurant new]];
    [self assertSecondLastStatementIs:@"U:WantsToSearchForAnotherRestaurant" userAction:nil];
    [self assertLastStatementIs:@"FH:OpeningQuestion" userAction:[AskUserCuisinePreferenceAction class]];

    [self.conversation addToken:[UCuisinePreference create:@"norwegian food"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
}

- (void)test_UWantsToSearchForAnotherRestaurant_ShouldTriggerFHAskCuisinePreferenceAndThenFHSuggestsAnotherRestaurant {
    [self.conversation addToken:[USuggestionFeedbackForLiking create:_restaurant]];
    [self.conversation addToken:[UWantsToSearchForAnotherRestaurant new]];

    [self assertSecondLastStatementIs:@"U:WantsToSearchForAnotherRestaurant" userAction:nil];
    [self assertLastStatementIs:@"FH:OpeningQuestion" userAction:[AskUserCuisinePreferenceAction class]];

    [self.conversation addToken:[UCuisinePreference create:@"norwegian food"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
}

@end