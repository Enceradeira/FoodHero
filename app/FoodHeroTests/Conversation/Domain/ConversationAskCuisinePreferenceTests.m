//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationTestsBase.h"

@interface ConversationAskCuisinePreferenceTests : ConversationTestsBase
@end

@implementation ConversationAskCuisinePreferenceTests {

}

- (void)test_UCuisinePreference_ShouldAddUserStatement {
    [self.conversation addToken:[UCuisinePreference create:@"Test" text:@"Test"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=Test" userAction:nil];
}

- (void)test_UCuisinePreference_ShouldTriggerRestaurantSearch {
    [self.conversation addToken:[UCuisinePreference create:@"Test" text:@"Test"]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
}

@end