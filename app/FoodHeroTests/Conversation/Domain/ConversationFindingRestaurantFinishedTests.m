//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTestsBase.h"
#import "RestaurantBuilder.h"


@interface ConversationFindingRestaurantFinishedTests : ConversationTestsBase
@end

@implementation ConversationFindingRestaurantFinishedTests {

    Restaurant *_restaurant;
    CLLocation *_london;
}

- (void)setUp {
    [super setUp];
    _restaurant = [[RestaurantBuilder alloc] build];
    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I love British Food"]];

}

- (void)test_USuggestionFeedbackForLike_ShouldAskUserWhatToDoNext {
    [self sendInput:[UserUtterances suggestionFeedbackForLike:_restaurant text:@"I like it"]];

    [self assertLastStatementIs:@"FH:WhatToDoNextCommentAfterSuccess" state:[FHStates askForWhatToDoNext]];
}

- (void)test_UGoodBye_ShouldTriggerFHGoodByeAfterSuccessAndThenLetTheUserToSearchForAnotherRestaurant {
    [self sendInput:[UserUtterances suggestionFeedbackForLike:_restaurant text:@"I like it"]];

    [self sendInput:[UserUtterances goodBye:@"Bye, Bye"]];
    [self assertSecondLastStatementIs:@"U:GoodBye" state:nil];
    [self assertLastStatementIs:@"FH:GoodByeAfterSuccess" state:[FHStates askForWhatToDoNext]];

    [self sendInput:[UserUtterances wantsToSearchForAnotherRestaurant:@"Search again, please"]];
    [self assertSecondLastStatementIs:@"U:WantsToSearchForAnotherRestaurant" state:nil];
    [self assertLastStatementIs:@"FH:OpeningQuestion" state:[FHStates askForFoodPreference]];

    [self sendInput:[UserUtterances cuisinePreference:@"norwegian food" text:@"norwegian food"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_UWantsToSearchForAnotherRestaurant_ShouldTriggerFHAskCuisinePreferenceAndThenFHSuggestsAnotherRestaurant {
    [self sendInput:[UserUtterances suggestionFeedbackForLike:_restaurant text:@"I like it"]];
    [self sendInput:[UserUtterances wantsToSearchForAnotherRestaurant:@"Again please"]];

    [self assertSecondLastStatementIs:@"U:WantsToSearchForAnotherRestaurant" state:nil];
    [self assertLastStatementIs:@"FH:OpeningQuestion" state:[FHStates askForFoodPreference]];

    [self sendInput:[UserUtterances cuisinePreference:@"norwegian food" text:@"norwegian food"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:[FHStates askForSuggestionFeedback]];
}

@end