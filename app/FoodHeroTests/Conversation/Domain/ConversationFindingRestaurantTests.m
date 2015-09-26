//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTestsBase.h"
#import "RestaurantBuilder.h"
#import "FoodHeroTests-Swift.h"

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
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Test" location:nil ] text:@"Test"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=Test" state:nil];
}

- (void)test_UCuisinePreference_ShouldTriggerRestaurantSearch {
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Test" location:nil ] text:@"Test"]];

    [self assertLastStatementIs:@"FH:Suggestion" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_UDidResolveProblemWithAccessLocationServiceOrUsersTriesAgain_ShouldBeHandledRepeatably {

    // Problem with kCLAuthorizationStatusRestricted
    [self configureRestaurantSearchForLatitude:12 longitude:1 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindSomething];
    }];
    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusRestricted];

    [self resetConversationWhenIsWithFeedbackRequest:NO];
    [self sendInput:[UserUtterances tryAgainNow:@"Again please"]];  // tries again but not no authorization present
    [self assertLastStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" state:[FHStates afterCantAccessLocationService]];

    // Problem with kCLAuthorizationStatusRestricted repeats
    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self sendInput:[UserUtterances tryAgainNow:@"I fixed it again"]];
    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" state:[FHStates afterCantAccessLocationService]];

    // All Problems fixed
    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusAuthorizedAlways];
    [self sendInput:[UserUtterances tryAgainNow:@"I fixed it again"]];
    [self assertLastStatementIs:@"FH:Suggestion" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHCanFindRestaurant_WhenAfterConsecutiveProposals {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Test" location:nil ] text:@"Test"]];

    [self configureRestaurantSearchForLatitude:12 longitude:44 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindNothing];
    }];

    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheapRestaurant text:@"It looks too cheap"]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:[FHStates noRestaurantWasFound]];
    [self sendInput:[UserUtterances tryAgainNow:@"Again please"]];
    [self assertLastStatementIs:@"FH:OpeningQuestion" state:[FHStates askForFoodPreference]];

    [self configureRestaurantSearchForLatitude:22 longitude:1 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindSomething];
    }];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"India" location:nil ] text:@"Indian"]];
    [self assertLastStatementIs:@"FH:Suggestion" state:[FHStates askForSuggestionFeedback]];

    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheapRestaurant text:@"It looks too cheap"]];
    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" state:[FHStates afterCantAccessLocationService]];

    [self sendInput:[UserUtterances tryAgainNow:@"I fixed it"]];
    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" state:[FHStates afterCantAccessLocationService]];

    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusAuthorizedAlways];
    [self configureRestaurantSearchForLatitude:25 longitude:-12 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindNothing];
    }];
    [self sendInput:[UserUtterances tryAgainNow:@"I fixed it again"]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:[FHStates noRestaurantWasFound]];
    [self configureRestaurantSearchForLatitude:-42 longitude:0 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindSomething];
    }];

    [self sendInput:[UserUtterances tryAgainNow:@"Again please!"]];
    [self assertLastStatementIs:@"FH:OpeningQuestion" state:[FHStates askForFoodPreference]];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"India" location:nil ] text:@"Indian"]];

    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheapRestaurant text:@"It looks too cheap"]];
    [self assertLastStatementIs:@"FH:Suggestion" state:[FHStates askForSuggestionFeedback]];

    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheapRestaurant text:@"It looks too cheap"]];
    [self assertLastStatementIs:@"FH:Suggestion" state:[FHStates askForSuggestionFeedback]];
}

@end