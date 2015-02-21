//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "UTryAgainNow.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "RestaurantBuilder.h"

@interface ConversationFindingRestaurantTests : ConversationTestsBase
@end

@implementation ConversationFindingRestaurantTests {

}

- (void)test_UCuisinePreference_ShouldAddUserStatement {
    [self sendInput:[UCuisinePreference createUtterance:@"Test" text:@"Test"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=Test" state:nil];
}

- (void)test_UCuisinePreference_ShouldTriggerRestaurantSearch {
    [self sendInput:[UCuisinePreference createUtterance:@"Test" text:@"Test"]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_UDidResolveProblemWithAccessLocationServiceOrUsersTriesAgain_ShouldBeHandledRepeatably {
    // Problem no restaurant found repeats
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I love British Food"]];
    [self.conversation addFHToken:[UTryAgainNow new]];
    [self.conversation addFHToken:[UTryAgainNow new]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:@"noRestaurantWasFound"];

    // Problem with kCLAuthorizationStatusRestricted repeats
    [self configureRestaurantSearchForLatitude:12 longitude:1 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];
    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [self.conversation addFHToken:[UTryAgainNow new]];   // tries again but not no authorization present
    [self.conversation addFHToken:[UDidResolveProblemWithAccessLocationService new]];
    [self assertLastStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" state:@"afterCantAccessLocationService"];

    // Problem with kCLAuthorizationStatusRestricted repeats
    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addFHToken:[UDidResolveProblemWithAccessLocationService new]];
    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" state:@"afterCantAccessLocationService"];

    // Problem no restaurant found again
    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusAuthorizedAlways];
    [self configureRestaurantSearchForLatitude:-56 longitude:10 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self.conversation addFHToken:[UDidResolveProblemWithAccessLocationService new]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:@"noRestaurantWasFound"];

    // Problems finally solved
    [self configureRestaurantSearchForLatitude:-10 longitude:0 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];
    [self.conversation addFHToken:[UTryAgainNow new]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHCanFindRestaurant_WhenAfterConsecutiveProposals {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    [self.tokenRandomizerStub injectDontDo:@"FH:Comment"];

    [self sendInput:[UCuisinePreference createUtterance:@"Test" text:@"Test"]];

    [self configureRestaurantSearchForLatitude:12 longitude:44 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];

    [self.conversation addFHToken:[USuggestionFeedbackForTooCheap create:cheapRestaurant text:@"It looks too cheap"]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:@"noRestaurantWasFound"];
    [self.conversation addFHToken:[UTryAgainNow new]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:@"noRestaurantWasFound"];

    [self configureRestaurantSearchForLatitude:22 longitude:1 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];
    [self.conversation addFHToken:[UTryAgainNow new]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];

    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addFHToken:[USuggestionFeedbackForTooCheap create:cheapRestaurant text:@"It looks too cheap"]];
    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" state:@"afterCantAccessLocationService"];

    [self.conversation addFHToken:[UDidResolveProblemWithAccessLocationService new]];
    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" state:@"afterCantAccessLocationService"];

    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusAuthorizedAlways];
    [self configureRestaurantSearchForLatitude:25 longitude:-12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self.conversation addFHToken:[UDidResolveProblemWithAccessLocationService new]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:@"noRestaurantWasFound"];
    [self configureRestaurantSearchForLatitude:-42 longitude:0 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];

    [self.conversation addFHToken:[UTryAgainNow new]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];

    [self.conversation addFHToken:[USuggestionFeedbackForTooCheap create:cheapRestaurant text:@"It looks too cheap"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];

    [self.conversation addFHToken:[USuggestionFeedbackForTooCheap create:cheapRestaurant text:@"It looks too cheap"]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

@end