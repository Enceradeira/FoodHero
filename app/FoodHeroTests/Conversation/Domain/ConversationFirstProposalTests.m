//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "AlternationRandomizerStub.h"
#import "USuggestionFeedbackForTooCheap.h"

@interface ConversationFirstProposalTests : ConversationTestsBase
@end

@implementation ConversationFirstProposalTests {

}

- (void)setUp {
    [super setUp];

    [self.tokenRandomizerStub injectDontDo:@"FH:Comment"];
}


- (void)test_USuggestionFeedback_ShouldAddUserStatement {
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:[Restaurant new]]];

    [self assertSecondLastStatementIs:@"U:SuggestionFeedback=It looks too cheap" userAction:nil];
}


- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenRandomizerWouldChooseFHSuggestionAsFollowUp{
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionAsFollowUp"];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    // Because it's the first suggestion, FHSuggestionAsFollowUp is not a valid option
    [super assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

@end