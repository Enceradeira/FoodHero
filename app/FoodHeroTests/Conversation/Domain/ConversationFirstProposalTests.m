//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationTestsBase.h"
#import "USuggestionFeedback.h"
#import "AlternationRandomizerStub.h"

@interface ConversationFirstProposalTests : ConversationTestsBase
@end

@implementation ConversationFirstProposalTests {

}

- (void)test_USuggestionFeedback_ShouldAddUserStatement {
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedback createForRestaurant:[Restaurant new] parameter:@"too expensive"]];

    [self assertSecondLastStatementIs:@"U:SuggestionFeedback" userAction:nil];
}


- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenRandomizerWouldChooseFHSuggestionAsFollowUp{
    [self.alternationRandomizerStub injectChoice:@"FH:SuggestionAsFollowUp"];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    // Because it's the first suggestion, FHSuggestionAsFollowUp is not a valid option
    [super assertLastStatementIs:@"FH:Suggestion=Kings Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

@end