//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationFindingRestaurantTests.h"
#import "UCuisinePreference.h"
#import "ConversationCantAccessLocationServiceTests.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"


@implementation ConversationCantAccessLocationServiceTests {

}

- (void)test_FHBecauseUserDeniedAccessToLocationServices_ShouldAddFHStatement {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];
}

- (void)test_FHBecauseUserIfNotAllowedToUseLocationServices_ShouldAddFHStatement {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self assertLastStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserDeniesAccessWhileBeingAskedNow {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];

    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" userAction:[AskUserIfProblemWithAccessLocationServiceResolved class]];
}


@end