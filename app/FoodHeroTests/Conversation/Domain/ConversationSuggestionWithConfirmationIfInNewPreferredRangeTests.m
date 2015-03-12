//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTestsBase.h"
#import "RestaurantBuilder.h"

@interface ConversationSuggestionWithConfirmationIfInNewPreferredRangeTests : ConversationTestsBase
@end

@implementation ConversationSuggestionWithConfirmationIfInNewPreferredRangeTests {

    Restaurant *_restaurant;
    CLLocation *_london;
}

- (void)setUp {
    [super setUp];

    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];
    _restaurant = [[RestaurantBuilder alloc] build];
    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants proposal] index :2];
    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I love British Food"]];
}


- (void)test_USuggestionFeedbackForTooExpensive_ShouldTriggerFHConfirmationIfInNewPreferredRangeCheaper {
    Restaurant *expensiveRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:4] build];
    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:expensiveRestaurant currentUserLocation:_london text:@"Way to expensive"]];

    [super assertLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeCheaper=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_USuggestionFeedbackForTooFarAways_ShouldTriggerFHConfirmationIfInNewPreferredRangeCloser {
    [self sendInput:[UserUtterances suggestionFeedbackForTooFarAway:_restaurant currentUserLocation:[CLLocation new] text:@"too far"]];

    [super assertLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeCloser=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_USuggestionFeedbackForTooCheap_ShouldTriggerFHConfirmationIfInNewPreferredRangeMoreExpensive {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheapRestaurant currentUserLocation:_london text:@"It looks cheap"]];

    [super assertLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

@end