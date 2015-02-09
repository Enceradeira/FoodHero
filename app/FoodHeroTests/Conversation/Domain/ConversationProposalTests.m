//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "RandomizerStub.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "RestaurantBuilder.h"
#import "USuggestionFeedbackForTooCheap.h"

@interface ConversationProposalTests : ConversationTestsBase
@end

@implementation ConversationProposalTests {

}

- (void)setUp {
    [super setUp];

    // Move Conversation into ProposalState by going through FirstProposal)
    [self.conversation addFHToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];

}

- (void)test_USuggestionFeedback_ShouldRepeatFHSuggestionByUsingDifferentTypesOfSuggestionFeedbacks {
    CLLocation *location = [CLLocation new];
    [self.tokenRandomizerStub injectDontDo:@"FH:Comment"];

    // 1. branch (FH:SuggestionAsFollowUp)
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionAsFollowUp"];
    [self.conversation addFHToken:[USuggestionFeedbackForTooFarAway create:[[RestaurantBuilder alloc] build] currentUserLocation:location text:nil]];
    [super assertLastStatementIs:@"FH:SuggestionAsFollowUp=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];

    [self.conversation addFHToken:[USuggestionFeedbackForTooExpensive create:[[[RestaurantBuilder alloc] withPriceLevel:4] build] text:nil]];
    [super assertLastStatementIs:@"FH:SuggestionAsFollowUp=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];

    // 1. branch (FH:Suggestion)
    [self.tokenRandomizerStub injectChoice:@"FH:Suggestion"];
    [self.conversation addFHToken:[USuggestionFeedbackForTooFarAway create:[[RestaurantBuilder alloc] build] currentUserLocation:location text:nil]];
    [super assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];

    // 2. branch (FH:SuggestionWithComment)
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionWithComment"];
    [self.conversation addFHToken:[USuggestionFeedbackForTooFarAway create:[[RestaurantBuilder alloc] build] currentUserLocation:location text:nil]];
    [super assertSecondLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeCloser=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
    [super assertLastStatementIs:@"FH:Confirmation" userAction:nil];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenUSuggestionFeedbackForNotLikingAtAllAndFHSuggestionAsFollowUp {
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionAsFollowUp"];

    [self.conversation addFHToken:[USuggestionFeedbackForNotLikingAtAll create:[[RestaurantBuilder alloc] build] text:@"I don't like that restaurant"]];

    [super assertLastStatementIs:@"FH:SuggestionAsFollowUp=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenUSuggestionFeedbackForNotLikingAtAllAndFHSuggestionWithComment {
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionWithComment"];

    [self.conversation addFHToken:[USuggestionFeedbackForNotLikingAtAll create:[[RestaurantBuilder alloc] build] text:@"I don't like that restaurant"]];

    [super assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenUSuggestionFeedbackForNotLikingAtAllAndFHSuggestion {
    [self.tokenRandomizerStub injectChoice:@"FH:Suggestnion"];

    [self.conversation addFHToken:[USuggestionFeedbackForNotLikingAtAll create:[[RestaurantBuilder alloc] build] text:@"I don't like that restaurant"]];

    [super assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHWarningIfNotInPreferredRangeTooCheapAndFHSuggestionAfterWarning_WhenFoundRestaurantIsTooCheap {

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];
    Restaurant *onlyOtherOption = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Chippy"] build];
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *service) {
        [service injectFindResults:@[onlyOtherOption]];
    }];

    [self.conversation addFHToken:[USuggestionFeedbackForTooCheap create:restaurant text:@"It looks too cheap"]];

    [super assertSecondLastStatementIs:@"FH:WarningIfNotInPreferredRangeTooCheap" userAction:nil];
    [super assertLastStatementIs:@"FH:SuggestionAfterWarning=Chippy, 18 Cathedral Street, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldNotTriggerFHWarningIfNotInPreferredRangeTooCheap_WhenUserHasAlreadyBeenWarnedBefore {

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];
    Restaurant *otherOption1 = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Chippy"] build];
    Restaurant *otherOption2 = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Hot cook"] build];
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *service) {
        [service injectFindResults:@[otherOption1, otherOption2]];
    }];

    [self.conversation addFHToken:[USuggestionFeedbackForTooCheap create:restaurant text:@"It looks too cheap"]];  // User is going to be warned with FH:WarningIfNotInPreferredRangeTooCheap"
    [self.conversation addFHToken:[USuggestionFeedbackForNotLikingAtAll create:otherOption1 text:@"I don't like that restaurant"]];

    [super assertLastStatementIs:@"FH:Suggestion=Hot cook, 18 Cathedral Street, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHWarningIfNotInPreferredRangeTooExpensiveAndFHSuggestionAfterWarning_WhenFoundRestaurantIsTooExpensive {
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];
    Restaurant *onlyOtherOption = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Chippy"] build];
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *service) {
        [service injectFindResults:@[onlyOtherOption]];
    }];

    [self.conversation addFHToken:[USuggestionFeedbackForTooExpensive create:restaurant text:nil]];

    [super assertSecondLastStatementIs:@"FH:WarningIfNotInPreferredRangeTooExpensive" userAction:nil];
    [super assertLastStatementIs:@"FH:SuggestionAfterWarning=Chippy, 18 Cathedral Street, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldNotTriggerFHWarningIfNotInPreferredRangeTooExpensive_WhenUserHasAlreadyBeenWarnedBefore {

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];
    Restaurant *otherOption1 = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Chippy"] build];
    Restaurant *otherOption2 = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Hot cook"] build];
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *service) {
        [service injectFindResults:@[otherOption1, otherOption2]];
    }];

    [self.conversation addFHToken:[USuggestionFeedbackForTooExpensive create:restaurant text:nil]];  // User is going to be warned with FH:WarningIfNotInPreferredRangeTooExpensive
    [self.conversation addFHToken:[USuggestionFeedbackForNotLikingAtAll create:otherOption1 text:@"I don't like that restaurant"]];

    [super assertLastStatementIs:@"FH:Suggestion=Hot cook, 18 Cathedral Street, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHWarningIfNotInPreferredRangeTooFarAwayAndFHSuggestionAfterWarning_WhenFoundRestaurantIsTooFarAway {
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:45 longitude:0];
    CLLocation *farawayLocation = [[CLLocation alloc] initWithLatitude:60 longitude:-45];
    CLLocation *closerLocation = [[CLLocation alloc] initWithLatitude:45 longitude:1];

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withLocation:closerLocation] build];
    Restaurant *onlyOtherOption = [[[[RestaurantBuilder alloc] withLocation:farawayLocation] withName:@"Chippy"] build];
    [self configureRestaurantSearchForLatitude:45 longitude:0 configuration:^(RestaurantSearchServiceStub *service) {
        [service injectFindResults:@[onlyOtherOption]];
    }];

    [self.conversation addFHToken:[USuggestionFeedbackForTooFarAway create:restaurant currentUserLocation:userLocation text:nil]];

    [super assertSecondLastStatementIs:@"FH:WarningIfNotInPreferredRangeTooFarAway" userAction:nil];
    [super assertLastStatementIs:@"FH:SuggestionAfterWarning=Chippy, 18 Cathedral Street, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldNotTriggerFHWarningIfNotInPreferredRangeTooFarAway_WhenUserHasAlreadyBeenWarnedBefore {
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:45 longitude:0];
    CLLocation *farawayLocation = [[CLLocation alloc] initWithLatitude:60 longitude:-45];
    CLLocation *closerLocation = [[CLLocation alloc] initWithLatitude:45 longitude:1];

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withLocation:closerLocation] build];
    Restaurant *otherOption1 = [[[[RestaurantBuilder alloc] withLocation:farawayLocation] withName:@"Chippy"] build];
    Restaurant *otherOption2 = [[[[RestaurantBuilder alloc] withLocation:farawayLocation] withName:@"Hot cook"] build];
    [self configureRestaurantSearchForLatitude:45 longitude:0 configuration:^(RestaurantSearchServiceStub *service) {
        [service injectFindResults:@[otherOption1, otherOption2]];
    }];

    [self.conversation addFHToken:[USuggestionFeedbackForTooFarAway create:restaurant currentUserLocation:userLocation text:nil]];  // User is going to be warned with FH:WarningIfNotInPreferredRangeTooFarAway
    [self.conversation addFHToken:[USuggestionFeedbackForNotLikingAtAll create:otherOption1 text:@"I don't like that restaurant"]];

    [super assertLastStatementIs:@"FH:Suggestion=Hot cook, 18 Cathedral Street, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

@end