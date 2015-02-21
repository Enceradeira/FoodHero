//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "ConversationTestsBase.h"

@interface ConversationAskCuisinePreferenceTests : ConversationTestsBase
@end

@implementation ConversationAskCuisinePreferenceTests {

}

- (void)test_UCuisinePreference_ShouldAddUserStatement {
    [self sendInput:[UCuisinePreference createUtterance:@"Test" text:@"Test"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=Test" state:nil];
}

- (void)test_UCuisinePreference_ShouldTriggerRestaurantSearch {
    [self sendInput:[UCuisinePreference createUtterance:@"Test" text:@"Test"]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

@end