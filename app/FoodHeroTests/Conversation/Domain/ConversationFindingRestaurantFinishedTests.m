//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "USuggestionFeedbackForLiking.h"
#import "UGoodBye.h"
#import "UWantsToSearchForAnotherRestaurant.h"
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

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I love British Food"]];

}

- (void)test_USuggestionFeedbackForLiking_ShouldAskUserWhatToDoNext {
    [self sendInput:[USuggestionFeedbackForLiking createUtterance:_restaurant currentUserLocation:_london text:@"I like it"]];

    [self assertLastStatementIs:@"FH:WhatToDoNextCommentAfterSuccess" state:@"askForWhatToDoNext"];
}

- (void)test_UGoodBye_ShouldTriggerFHGoodByeAfterSuccessAndThenLetTheUserToSearchForAnotherRestaurant {
    [self sendInput:[USuggestionFeedbackForLiking createUtterance:_restaurant currentUserLocation:_london text:@"I like it"]];

    [self sendInput:[UGoodBye createUtterance:@"Bye, Bye"]];
    [self assertSecondLastStatementIs:@"U:GoodBye" state:nil];
    [self assertLastStatementIs:@"FH:GoodByeAfterSuccess" state:@"afterGoodByeAfterSuccess"];

    [self sendInput:[UWantsToSearchForAnotherRestaurant createUtterance:@"Search again, please"]];
    [self assertSecondLastStatementIs:@"U:WantsToSearchForAnotherRestaurant" state:nil];
    [self assertLastStatementIs:@"FH:OpeningQuestion" state:@"askForFoodPreference"];

    [self sendInput:[UCuisinePreference createUtterance:@"norwegian food" text:@"norwegian food"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_UWantsToSearchForAnotherRestaurant_ShouldTriggerFHAskCuisinePreferenceAndThenFHSuggestsAnotherRestaurant {
    [self sendInput:[USuggestionFeedbackForLiking createUtterance:_restaurant currentUserLocation:_london text:@"I like it"]];
    [self sendInput:[UWantsToSearchForAnotherRestaurant createUtterance:@"Again please"]];

    [self assertSecondLastStatementIs:@"U:WantsToSearchForAnotherRestaurant" state:nil];
    [self assertLastStatementIs:@"FH:OpeningQuestion" state:@"askForFoodPreference"];

    [self sendInput:[UCuisinePreference createUtterance:@"norwegian food" text:@"norwegian food"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

@end