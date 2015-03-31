//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTestsBase.h"
#import "RestaurantBuilder.h"

@interface ConversationFindingRestaurantTests : ConversationTestsBase
@end

@implementation ConversationFindingRestaurantTests {

    CLLocation *_london;
}

- (void)setUp {
    [super setUp];

    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];
}

- (void)test_UCuisinePreference_ShouldAddUserStatement {
    [self sendInput:[UserUtterances cuisinePreference:@"Test" text:@"Test"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=Test" state:nil];
}

- (void)test_UCuisinePreference_ShouldTriggerRestaurantSearch {
    [self sendInput:[UserUtterances cuisinePreference:@"Test" text:@"Test"]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_UDidResolveProblemWithAccessLocationServiceOrUsersTriesAgain_ShouldBeHandledRepeatably {
    // Problem no restaurant found repeats
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I love British Food"]];
    [self sendInput:[UserUtterances tryAgainNow:@"Again please"]];
    [self sendInput:[UserUtterances tryAgainNow:@"Again please!"]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:[FHStates noRestaurantWasFound]];

    // Problem with kCLAuthorizationStatusRestricted repeats
    [self configureRestaurantSearchForLatitude:12 longitude:1 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];
    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [self sendInput:[UserUtterances tryAgainNow:@"Again please"]];  // tries again but not no authorization present
    [self assertLastStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" state:[FHStates afterCantAccessLocationService]];

    // Problem with kCLAuthorizationStatusRestricted repeats
    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self sendInput:[UserUtterances tryAgainNow:@"I fixed it again"]];
    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" state:[FHStates afterCantAccessLocationService]];

    // Problem no restaurant found again
    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusAuthorizedAlways];
    [self configureRestaurantSearchForLatitude:-56 longitude:10 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self sendInput:[UserUtterances tryAgainNow:@"I fixed it again"]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:[FHStates noRestaurantWasFound]];

    // Problems finally solved
    [self configureRestaurantSearchForLatitude:-10 longitude:0 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];
    [self sendInput:[UserUtterances tryAgainNow:@"Again please"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHCanFindRestaurant_WhenAfterConsecutiveProposals {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    [self sendInput:[UserUtterances cuisinePreference:@"Test" text:@"Test"]];

    [self configureRestaurantSearchForLatitude:12 longitude:44 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];

    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheapRestaurant text:@"It looks too cheap"]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:[FHStates noRestaurantWasFound]];
    [self sendInput:[UserUtterances tryAgainNow:@"Again please"]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:[FHStates noRestaurantWasFound]];

    [self configureRestaurantSearchForLatitude:22 longitude:1 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];
    [self sendInput:[UserUtterances tryAgainNow:@"Again please!"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:[FHStates askForSuggestionFeedback]];

    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheapRestaurant text:@"It looks too cheap"]];
    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" state:[FHStates afterCantAccessLocationService]];

    [self sendInput:[UserUtterances tryAgainNow:@"I fixed it"]];
    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" state:[FHStates afterCantAccessLocationService]];

    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusAuthorizedAlways];
    [self configureRestaurantSearchForLatitude:25 longitude:-12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self sendInput:[UserUtterances tryAgainNow:@"I fixed it again"]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:[FHStates noRestaurantWasFound]];
    [self configureRestaurantSearchForLatitude:-42 longitude:0 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];

    [self sendInput:[UserUtterances tryAgainNow:@"Again please!"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:[FHStates askForSuggestionFeedback]];

    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheapRestaurant text:@"It looks too cheap"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:[FHStates askForSuggestionFeedback]];

    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheapRestaurant text:@"It looks too cheap"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:[FHStates askForSuggestionFeedback]];
}

@end