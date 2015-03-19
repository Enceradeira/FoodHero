//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTestsBase.h"

@interface ConversationCantAccessLocationServiceTests : ConversationTestsBase
@end

@implementation ConversationCantAccessLocationServiceTests {

}

- (void)test_FHBecauseUserDeniedAccessToLocationServices_ShouldAddFHStatement {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I love British Food"]];

    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" state:[FHStates afterCantAccessLocationService]];
}

- (void)test_FHBecauseUserIfNotAllowedToUseLocationServices_ShouldAddFHStatement {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I love British Food"]];

    [self assertLastStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" state:[FHStates afterCantAccessLocationService]];
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserDeniesAccessWhileBeingAskedNow {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I love British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];

    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" state:[FHStates afterCantAccessLocationService]];
}


@end