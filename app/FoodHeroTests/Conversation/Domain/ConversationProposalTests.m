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

@interface ConversationProposalTests : ConversationTestsBase
@end

@implementation ConversationProposalTests {

}

- (void)setUp {
    [super setUp];

    // Move Conversation into ProposalState by going through FirstProposal)
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

}

- (void)test_USuggestionFeedback_ShouldRepeatSuggestionByUsingDifferentTypesOfSuggestionFeedbacks {
    [self.tokenRandomizerStub injectDontDo:@"FH:Comment"];

    // 1. branch (FH:SuggestionAsFollowUp)
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionAsFollowUp"];
    [self.conversation addToken:[USuggestionFeedbackForTooFarAway create:[Restaurant new]]];
    [super assertLastStatementIs:@"FH:SuggestionAsFollowUp=Kings Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];

    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:[Restaurant new]]];
    [super assertLastStatementIs:@"FH:SuggestionAsFollowUp=Kings Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];

    // 1. branch (FH:Suggestion)
    [self.tokenRandomizerStub injectChoice:@"FH:Suggestion"];
    [self.conversation addToken:[USuggestionFeedbackForTooFarAway create:[Restaurant new]]];
    [super assertLastStatementIs:@"FH:Suggestion=Kings Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];

    // 2. branch (FH:SuggestionWithComment)
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionWithComment"];
    [self.conversation addToken:[USuggestionFeedbackForTooFarAway create:[Restaurant new]]];
    [super assertSecondLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeCloser=Kings Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
    [super assertLastStatementIs:@"FH:Confirmation" userAction:nil];
}

@end