//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "RandomizerStub.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "RestaurantBuilder.h"

@interface ConversationSuggestionWithConfirmationIfInNewPreferredRangeTests : ConversationTestsBase
@end

@implementation ConversationSuggestionWithConfirmationIfInNewPreferredRangeTests {

    Restaurant *_restaurant;
}

- (void)setUp {
    [super setUp];

    _restaurant = [[RestaurantBuilder alloc] build];
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionWithComment"];
    [self.conversation addToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];
}


- (void)test_USuggestionFeedbackForTooExpensive_ShouldTriggerFHConfirmationIfInNewPreferredRangeCheaper {
    Restaurant *expensiveRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:4] build];
    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:expensiveRestaurant]];

    [super assertSecondLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeCheaper=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
}

- (void)test_USuggestionFeedbackForTooFarAways_ShouldTriggerFHConfirmationIfInNewPreferredRangeCloser {
    [self.conversation addToken:[USuggestionFeedbackForTooFarAway create:_restaurant currentUserLocation:[CLLocation new]]];

    [super assertSecondLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeCloser=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
}

- (void)test_USuggestionFeedbackForTooCheap_ShouldTriggerFHConfirmationIfInNewPreferredRangeMoreExpensive {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:cheapRestaurant]];

    [super assertSecondLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
}

@end