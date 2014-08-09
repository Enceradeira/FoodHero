//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"
#import "UTryAgainNow.h"
#import "AskUserToTryAgainAction.h"
#import "ConversationTestsBase.h"


@interface ConversationCantFindRestaurantTests : ConversationTestsBase
@end

@implementation ConversationCantFindRestaurantTests {

}

- (void)test_UDidResolveProblemWithAccessLocationService_ShouldAddFHSuggestion_WhenProblemIsResolvedNow {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusAuthorized];
    [self.conversation addToken:[UDidResolveProblemWithAccessLocationService new]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_UDidResolveProblemWithAccessLocationService_ShouldAddFHBecauseUserDeniedAccessToLocationServices_WhenProblemIsStillUnresolved {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [self.conversation addToken:[UDidResolveProblemWithAccessLocationService new]];

    [self assertLastStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];
}

-(void)test_UTryAgainNow_ShouldAddFHSuggestion_WhenRestaurantsFoundNow{
    [self.restaurantSearchStub injectFindNothing];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.restaurantSearchStub injectFindSomething];
    [self.conversation addToken:[UTryAgainNow new]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

-(void)test_UTrayAgainNow_ShouldAddNoRestaurantFound_WhenStillNoRestaurantsFound{
    [self.restaurantSearchStub injectFindNothing];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.restaurantSearchStub injectFindNothing];
    [self.conversation addToken:[UTryAgainNow new]];

    [self assertLastStatementIs:@"FH:NoRestaurantsFound" userAction:AskUserToTryAgainAction .class];
}

@end