//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationTestsBase.h"
#import "USuggestionFeedback.h"
#import "AlternationRandomizerStub.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooCheap.h"

@interface ConversationSuggestionWithConfirmationIfInNewPreferredRangeTests : ConversationTestsBase
@end

@implementation ConversationSuggestionWithConfirmationIfInNewPreferredRangeTests {

    Restaurant *_restaurant;
}

- (void)setUp {
    [super setUp];

    _restaurant = [Restaurant new];
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionWithComment"];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
}


- (void)test_USuggestionFeedbackForTooExpensive_ShouldTriggerFHConfirmationIfInNewPreferredRangeCheaper {
    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:_restaurant]];

    [super assertLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeCheaper=Kings Head, Norwich" userAction:nil];
}

- (void)test_USuggestionFeedbackForTooFarAways_ShouldTriggerFHConfirmationIfInNewPreferredRangeCloser {
    [self.conversation addToken:[USuggestionFeedbackForTooFarAway create:_restaurant]];

    [super assertLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeCloser=Kings Head, Norwich" userAction:nil];
}

- (void)test_USuggestionFeedbackForTooCheap_ShouldTriggerFHConfirmationIfInNewPreferredRangeMoreExpensive {
    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:_restaurant]];

    [super assertLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive=Kings Head, Norwich" userAction:nil];
}

@end