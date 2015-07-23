//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTestsBase.h"
#import "FoodHeroTests-Swift.h"


@interface ConversationCantFindRestaurantTests : ConversationTestsBase
@end

@implementation ConversationCantFindRestaurantTests {

}

- (void)test_UDidResolveProblemWithAccessLocationService_ShouldAddFHSuggestion_WhenProblemIsResolvedNow {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil ] text:@"I love British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusAuthorizedAlways];
    [self sendInput:[UserUtterances tryAgainNow:@""]];

    [self assertLastStatementIs:@"FH:Suggestion" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_UDidResolveProblemWithAccessLocationService_ShouldAddFHBecauseUserDeniedAccessToLocationServices_WhenProblemIsStillUnresolved {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil ] text:@"I love British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [self sendInput:[UserUtterances tryAgainNow:@""]];

    [self assertLastStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" state:[FHStates afterCantAccessLocationService]];
}

- (void)test_UTrayAgainNow_ShouldAddFHOpeningQuestion_WhenNoRestaurantsFound {
    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindNothing];
    }];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil ] text:@"I love British Food"]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:[FHStates noRestaurantWasFound]];

    [self sendInput:[UserUtterances tryAgainNow:@""]];
    [self assertLastStatementIs:@"FH:OpeningQuestion" state:[FHStates askForFoodPreference]];

}

- (void)test_UTrayAgainNow_ShouldAddFHSuggestion_WhenUsersGivesCuisinePreference {
    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindNothing];
    }];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil ] text:@"I love British Food"]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:[FHStates noRestaurantWasFound]];

    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindSomething];
    }];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Swiss Food" location:nil ] text:@"I love fondue"]];
    [self assertLastStatementIs:@"FH:Suggestion" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_UTrayAgainNow_ShouldAddFHSuggestion_WhenUsersGivesOccasionPreference {
    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindNothing];
    }];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil ] text:@"I love British Food"]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:[FHStates noRestaurantWasFound]];

    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindSomething];
    }];
    [self sendInput:[UserUtterances occasionPreference:[[TextAndLocation alloc] initWithText:@"drinks" location:nil ] text:@"I want drinks"]];
    [self assertLastStatementIs:@"FH:Suggestion" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_UWantsToAbort_ShouldAddWhatToDoNextAfterFailure {
    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindNothing];
    }];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil ] text:@"I love British Food"]];

    [self configureRestaurantSearchForLatitude:15.00 longitude:-10.23 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindNothing];
    }];

    [self sendInput:[UserUtterances wantsToAbort:@""]];
    [self assertLastStatementIs:@"FH:WhatToDoNextCommentAfterFailure" state:[FHStates askForWhatToDoNext]];
}

@end