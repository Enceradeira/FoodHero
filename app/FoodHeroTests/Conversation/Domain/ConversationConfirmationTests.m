//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <OCHamcrest.h>
#import "UCuisinePreference.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "AlternationRandomizerStub.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "RestaurantBuilder.h"

@interface ConversationConfirmationTests : ConversationTestsBase
@end

@implementation ConversationConfirmationTests {

    Restaurant *_restaurant;
}

- (void)setUp {
    [super setUp];

    _restaurant = [[RestaurantBuilder alloc] build];
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionWithComment"];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
}

- (void)test_USuggestionFeedbackForTooExpensive_ShouldTriggerFHConfirmationIfInNewPreferredRangeCheaper {
    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:_restaurant]];

    [super assertLastStatementIs:@"FH:Confirmation" userAction:nil];
}

@end