//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTestsBase.h"

@interface ConversationAskCuisinePreferenceTests : ConversationTestsBase
@end

@implementation ConversationAskCuisinePreferenceTests {

}

- (void)test_UCuisinePreference_ShouldAddUserStatement {
    [self sendInput:[UserUtterances dislikesKindOfFood:@"Indian"]];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Test" location:nil ] text:@"Test"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=Test" state:nil];
}

- (void)test_UCuisinePreference_ShouldTriggerRestaurantSearch {
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Test" location:nil ] text:@"Test"]];

    [self assertLastStatementIs:@"FH:Suggestion" state:[FHStates  askForSuggestionFeedback]];
}

-(void)test_UCuisinePreference_ShouldNotBeFollowedByFHFollowUpQuestion{
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Test" location:nil ] text:@"Test"]];

    [self assertLastStatementIs:@"FH:FollowUpQuestion" state:[FHStates  askForSuggestionFeedback]];
}

@end