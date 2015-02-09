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
#import "AskUserWhatToDoNextAction.h"
#import "UWantsToSearchForAnotherRestaurant.h"
#import "AskUserCuisinePreferenceAction.h"
#import "UWantsToAbort.h"


@interface ConversationCantFindRestaurantTests : ConversationTestsBase
@end

@implementation ConversationCantFindRestaurantTests {

}

- (void)test_UDidResolveProblemWithAccessLocationService_ShouldAddFHSuggestion_WhenProblemIsResolvedNow {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addFHToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusAuthorizedAlways];
    [self.conversation addFHToken:[UDidResolveProblemWithAccessLocationService new]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_UDidResolveProblemWithAccessLocationService_ShouldAddFHBecauseUserDeniedAccessToLocationServices_WhenProblemIsStillUnresolved {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addFHToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [self.conversation addFHToken:[UDidResolveProblemWithAccessLocationService new]];

    [self assertLastStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];
}

- (void)test_UTryAgainNow_ShouldAddFHSuggestion_WhenRestaurantsFoundNow {
    // user searches and finds nothing
    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self.conversation addFHToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];

    // user changes location and finds something
    [self configureRestaurantSearchForLatitude:12.00 longitude:-75.56 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];
    [self.conversation addFHToken:[UTryAgainNow new]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_UTrayAgainNow_ShouldAddNoRestaurantFound_WhenStillNoRestaurantsFound {
    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self.conversation addFHToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];

    [self configureRestaurantSearchForLatitude:15.00 longitude:-10.23 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self.conversation addFHToken:[UTryAgainNow new]];

    [self assertLastStatementIs:@"FH:NoRestaurantsFound" userAction:AskUserToTryAgainAction.class];
}

- (void)test_UWantsToAbort_ShouldAddWhatToDoNextAfterFailure {
    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self.conversation addFHToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];

    [self configureRestaurantSearchForLatitude:15.00 longitude:-10.23 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];

    [self.conversation addFHToken:[UWantsToAbort new]];
    [self assertLastStatementIs:@"FH:WhatToDoNextCommentAfterFailure" userAction:AskUserWhatToDoNextAction.class];
}

@end