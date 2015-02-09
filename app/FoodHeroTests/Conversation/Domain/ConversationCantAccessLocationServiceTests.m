//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"
#import "ConversationTestsBase.h"

@interface ConversationCantAccessLocationServiceTests : ConversationTestsBase
@end

@implementation ConversationCantAccessLocationServiceTests {

}

- (void)test_FHBecauseUserDeniedAccessToLocationServices_ShouldAddFHStatement {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addFHToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];

    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];
}

- (void)test_FHBecauseUserIfNotAllowedToUseLocationServices_ShouldAddFHStatement {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [self.conversation addFHToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];

    [self assertLastStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserDeniesAccessWhileBeingAskedNow {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [self.conversation addFHToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];

    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" userAction:[AskUserIfProblemWithAccessLocationServiceResolved class]];
}


@end