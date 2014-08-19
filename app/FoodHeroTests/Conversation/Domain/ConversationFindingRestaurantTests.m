//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "UTryAgainNow.h"
#import "AskUserToTryAgainAction.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "AlternationRandomizerStub.h"
#import "RestaurantBuilder.h"

@interface ConversationFindingRestaurantTests : ConversationTestsBase
@end

@implementation ConversationFindingRestaurantTests {

}

- (void)test_UCuisinePreference_ShouldAddUserStatement {
    [self.conversation addToken:[UCuisinePreference create:@"Test"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=Test" userAction:nil];
}

- (void)test_UCuisinePreference_ShouldTriggerRestaurantSearch {
    [self.conversation addToken:[UCuisinePreference create:@"Test"]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
}

- (void)test_UDidResolveProblemWithAccessLocationServiceOrUsersTriesAgain_ShouldBeHandledRepeatably {
    // Problem no restaurant found repeats
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[UTryAgainNow new]];
    [self.conversation addToken:[UTryAgainNow new]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" userAction:AskUserToTryAgainAction.class];

    // Problem with kCLAuthorizationStatusRestricted repeats
    [self configureRestaurantSearchForLatitude:12 longitude:1 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];
    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [self.conversation addToken:[UTryAgainNow new]];   // tries again but not no authorization present
    [self.conversation addToken:[UDidResolveProblemWithAccessLocationService new]];
    [self assertLastStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];

    // Problem with kCLAuthorizationStatusRestricted repeats
    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addToken:[UDidResolveProblemWithAccessLocationService new]];
    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];

    // Problem no restaurant found again
    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusAuthorized];
    [self configureRestaurantSearchForLatitude:-56 longitude:10 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self.conversation addToken:[UDidResolveProblemWithAccessLocationService new]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" userAction:AskUserToTryAgainAction.class];

    // Problems finally solved
    [self configureRestaurantSearchForLatitude:-10 longitude:0 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];
    [self.conversation addToken:[UTryAgainNow new]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHCanFindRestaurant_WhenAfterConsecutiveProposals {
    [self.tokenRandomizerStub injectDontDo:@"FH:Comment"];

    [self.conversation addToken:[UCuisinePreference create:@"Test"]];

    [self configureRestaurantSearchForLatitude:12 longitude:44 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];

    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:[[RestaurantBuilder alloc] build]]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" userAction:AskUserToTryAgainAction.class];
    [self.conversation addToken:[UTryAgainNow new]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" userAction:AskUserToTryAgainAction.class];

    [self configureRestaurantSearchForLatitude:22 longitude:1 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];
    [self.conversation addToken:[UTryAgainNow new]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];

    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:[[RestaurantBuilder alloc] build]]];
    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];

    [self.conversation addToken:[UDidResolveProblemWithAccessLocationService new]];
    [self assertLastStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" userAction:AskUserIfProblemWithAccessLocationServiceResolved.class];

    [self.locationManagerStub injectAuthorizationStatus:kCLAuthorizationStatusAuthorized];
    [self configureRestaurantSearchForLatitude:25 longitude:-12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];
    [self.conversation addToken:[UDidResolveProblemWithAccessLocationService new]];
    [self assertLastStatementIs:@"FH:NoRestaurantsFound" userAction:AskUserToTryAgainAction.class];
    [self configureRestaurantSearchForLatitude:-42 longitude:0 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindSomething];
    }];

    [self.conversation addToken:[UTryAgainNow new]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];

    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:[[RestaurantBuilder alloc] build]]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];

    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:[[RestaurantBuilder alloc] build]]];
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:[AskUserSuggestionFeedbackAction class]];
}

@end