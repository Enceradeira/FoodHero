//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTestsBase.h"
#import "RestaurantBuilder.h"

@interface ConversationConfirmationTests : ConversationTestsBase
@end

@implementation ConversationConfirmationTests {

    Restaurant *_restaurant;
    CLLocation *_london;
}

- (void)setUp {
    [super setUp];

    _restaurant = [[RestaurantBuilder alloc] build];
    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];
    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants proposal] index:2];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil ] text:@"I love British Food"]];
}

- (void)test_USuggestionFeedbackForTooExpensive_ShouldTriggerFHConfirmationIfInNewPreferredRangeCheaper {
    Restaurant *expensiveRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:4] build];

    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:expensiveRestaurant text:@"too posh"]];

    [super assertLastStatementIs:@"FH:Suggestion" state:[FHStates  askForSuggestionFeedback]];
}

@end