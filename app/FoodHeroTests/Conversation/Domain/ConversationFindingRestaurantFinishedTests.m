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

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil ] text:@"I love British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForLike:_restaurant text:@"I like it"]];
}

- (void)test_USuggestionFeedbackForLike_ShouldAskUserWhatToDoNext {
    [self assertLastStatementIs:@"FH:WhatToDoNextCommentAfterSuccess" state:[FHStates askForWhatToDoNext]];
}

 - (void)test_UWantsToStopConversation_ShouldMakeFHSayGoodbye{
     [self sendInput:[UserUtterances wantsToStopConversation:@"No, that's all"]];
     [self assertLastStatementIs:@"FH:GoodByeAfterSuccess" state:[FHStates conversationEnded]];

     [self sendInput:[UserUtterances goodBye:@"Goodbye"]];
     [self assertLastStatementIs:@"U:GoodBye" state:nil];
 }

- (void)test_WantsToSearchForAnotherRestaurant_ShouldMakeFHToSearchAgain{
    [self sendInput:[UserUtterances wantsToSearchForAnotherRestaurant:@"Search for another one"]];

    [self assertLastStatementIs:@"FH:OpeningQuestion" state:[FHStates askForFoodPreference]];
}

@end