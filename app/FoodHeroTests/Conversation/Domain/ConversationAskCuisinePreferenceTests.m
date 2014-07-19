//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationAskCuisinePreferenceTests.h"
#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"


@implementation ConversationAskCuisinePreferenceTests {

}

- (void)test_UCuisinePreference_ShouldAddUserStatement {
    NSUInteger index = self.conversation.getStatementCount;

    [self.conversation addToken:[UCuisinePreference create:@"Test"]];

    [self expectedStatementIs:@"U:CuisinePreference=Test" userAction:nil];
    [self assertExpectedStatementsAtIndex:index];
}

- (void)test_UCuisinePreference_ShouldTriggerRestaurantSearch {
    NSUInteger index = self.conversation.getStatementCount + 1;

    [self.conversation addToken:[UCuisinePreference create:@"Test"]];

    [self expectedStatementIs:@"FH:Suggestion=Kings Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
    [self assertExpectedStatementsAtIndex:index];
}

@end