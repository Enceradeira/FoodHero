//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationFindingRestaurantTests.h"
#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationCantFindRestaurantTests.h"
#import "ConversationCantAccessLocationServiceTests.h"
#import "FHBecauseUserDeniedAccessToLocationServices.h"
#import "AskUserToTryAgainAction.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"


@implementation ConversationCantAccessLocationServiceTests {

}

-(void)test_FHBecauseUserDeniedAccessToLocationServices_ShouldAddFHStatement{
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    NSUInteger index = self.conversation.getStatementCount-1;
    [self expectedStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];
    [self assertExpectedStatementsAtIndex:index];
}

-(void)test_FHBecauseUserIfNotAllowedToUseLocationServices_ShouldAddFHStatement{
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    NSUInteger index = self.conversation.getStatementCount-1;
    [self expectedStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];
    [self assertExpectedStatementsAtIndex:index];
}

-(void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserDeniesAccessWhileBeingAskedNow{
    NSUInteger indexOfFoodHeroResponse = [self.conversation getStatementCount]+1;

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];

    [self expectedStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" userAction:[AskUserIfProblemWithAccessLocationServiceResolved class]];
    [self assertExpectedStatementsAtIndex:indexOfFoodHeroResponse];
}


@end