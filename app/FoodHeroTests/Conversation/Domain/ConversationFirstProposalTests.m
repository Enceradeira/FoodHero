//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTestsBase.h"
#import "RestaurantBuilder.h"

@interface ConversationFirstProposalTests : ConversationTestsBase
@end

@implementation ConversationFirstProposalTests {

    CLLocation *_norwich;
}

- (void)setUp {
    [super setUp];

    _norwich = [[CLLocation alloc] initWithLatitude:52.631944 longitude:1.298889];
}


- (void)test_USuggestionFeedback_ShouldAddUserStatement {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil ] text:@"I love British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheapRestaurant text:@"It looks to cheap"]];

    [self assertSecondLastStatementIs:@"U:SuggestionFeedback=tooCheap" state:nil];
}


- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenRandomizerWouldChooseFHSuggestionAsFollowUp {
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil ] text:@"I love British Food"]];

    // Because it's the first suggestion, FHSuggestionAsFollowUp is not a valid option
    [super assertLastStatementIs:@"FH:Suggestion" state:[FHStates  askForSuggestionFeedback]];
}

@end