//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "UTryAgainNow.h"
#import "ConversationTestsBase.h"
#import "UWantsToAbort.h"


@interface ConversationCantFindRestaurantTests : ConversationTestsBase
@end

@implementation ConversationCantFindRestaurantTests {

}

- (void)test_UDidResolveProblemWithAccessLocationService_ShouldAddFHSuggestion_WhenProblemIsResolvedNow {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I love British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusAuthorizedAlways];
    [self sendInput:[UDidResolveProblemWithAccessLocationService createUtterance:@""]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_UDidResolveProblemWithAccessLocationService_ShouldAddFHBecauseUserDeniedAccessToLocationServices_WhenProblemIsStillUnresolved {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I love British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [self sendInput:[UDidResolveProblemWithAccessLocationService createUtterance:@""]];

    [self assertLastStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" state:@"afterCantAccessLocationService"];
}

- (void)test_UTryAgainNow_ShouldAddFHSuggestion_WhenRestaurantsFoundNow {
    // user searches and finds nothing
    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I love British Food"]];

    // user changes location and finds something
    [self configureRestaurantSearchForLatitude:12.00 longitude:-75.56 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];
    [self sendInput:[UTryAgainNow createUtterance:@""]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_UTrayAgainNow_ShouldAddNoRestaurantFound_WhenStillNoRestaurantsFound {
    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I love British Food"]];

    [self configureRestaurantSearchForLatitude:15.00 longitude:-10.23 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self sendInput:[UTryAgainNow createUtterance:@""]];

    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:@"noRestaurantWasFound"];
}

- (void)test_UWantsToAbort_ShouldAddWhatToDoNextAfterFailure {
    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I love British Food"]];

    [self configureRestaurantSearchForLatitude:15.00 longitude:-10.23 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];

    [self sendInput:[UWantsToAbort createUtterance:@""]];
    [self assertLastStatementIs:@"FH:WhatToDoNextCommentAfterFailure" state:@"askForWhatToDoNext"];
}

@end