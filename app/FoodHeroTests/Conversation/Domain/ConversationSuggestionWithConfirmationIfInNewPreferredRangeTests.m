//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooCheap.h"
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
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I love British Food"]];
}


- (void)test_USuggestionFeedbackForTooExpensive_ShouldTriggerFHConfirmationIfInNewPreferredRangeCheaper {
    Restaurant *expensiveRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:4] build];
    [self sendInput:[USuggestionFeedbackForTooExpensive createUtterance:expensiveRestaurant currentUserLocation:_london text:@"Way to expensive"]];

    [super assertLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeCheaper=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_USuggestionFeedbackForTooFarAways_ShouldTriggerFHConfirmationIfInNewPreferredRangeCloser {
    [self sendInput:[USuggestionFeedbackForTooFarAway createUtterance:_restaurant currentUserLocation:[CLLocation new] text:@"too far"]];

    [super assertLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeCloser=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_USuggestionFeedbackForTooCheap_ShouldTriggerFHConfirmationIfInNewPreferredRangeMoreExpensive {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    [self sendInput:[USuggestionFeedbackForTooCheap createUtterance:cheapRestaurant currentUserLocation:_london text:@"It looks cheap"]];

    [super assertLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

@end