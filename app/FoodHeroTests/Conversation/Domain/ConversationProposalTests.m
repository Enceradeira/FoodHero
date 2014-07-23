//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <OCHamcrest/OCHamcrest.h>
#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationTestsBase.h"
#import "USuggestionFeedback.h"
#import "AlternationRandomizerStub.h"

@interface ConversationProposalTests : ConversationTestsBase
@end

@implementation ConversationProposalTests {

}

-(void)setUp{
    [super setUp];

    // Move Conversation into ProposalState by going through FirstProposal)
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

}

- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestionAsFollowUp {
    [self.alternationRandomizerStub injectChoice:@"FH:SuggestionAsFollowUp"];

    [self.conversation addToken:[USuggestionFeedback createForRestaurant:[Restaurant new] parameter:@"too expensive"]];

    [super assertLastStatementIs:@"FH:SuggestionAsFollowUp=Kings Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

@end