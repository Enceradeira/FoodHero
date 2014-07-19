//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationFindingRestaurantTests.h"
#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationCantFindRestaurantTests.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"


@implementation ConversationCantFindRestaurantTests {

}


- (void)test_UDidResolveProblemWithAccessLocationService_ShouldAddFHSuggestion_WhenProblemIsResolvedNow {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusAuthorized];
    [self.conversation addToken:[UDidResolveProblemWithAccessLocationService new]];

    [self assertLastStatementIs:@"FH:Suggestion=Kings Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_UDidResolveProblemWithAccessLocationService_ShouldAddFHBecauseUserDeniedAccessToLocationServices_WhenProblemIsStillUnresolved {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [self.conversation addToken:[UDidResolveProblemWithAccessLocationService new]];

    [self assertLastStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];
}

@end