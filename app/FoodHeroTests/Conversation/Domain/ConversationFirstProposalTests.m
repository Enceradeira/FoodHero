//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationTestsBase.h"
#import "USuggestionFeedback.h"

@interface ConversationFirstProposalTests : ConversationTestsBase
@end

@implementation ConversationFirstProposalTests {

}

- (void)test_USuggestionFeedback_ShouldAddUserStatement {
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedback createForRestaurant:[Restaurant new] parameter:@"too expensive"]];

    [self assertSecondLastStatementIs:@"U:SuggestionFeedback" userAction:nil];
}


@end