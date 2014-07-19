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
    [self.conversation addToken:[UCuisinePreference create:@"Test"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=Test" userAction:nil];
}

- (void)test_UCuisinePreference_ShouldTriggerRestaurantSearch {
    [self.conversation addToken:[UCuisinePreference create:@"Test"]];

    [self assertLastStatementIs:@"FH:Suggestion=Kings Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
}

@end