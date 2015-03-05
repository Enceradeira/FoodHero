//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "RestaurantBuilder.h"
#import "USuggestionFeedbackForTooCheap.h"

@interface ConversationProposalTests : ConversationTestsBase
@end

@implementation ConversationProposalTests {

    CLLocation *_london;
}

- (void)setUp {
    [super setUp];
    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];

    // Move Conversation into ProposalState by going through FirstProposal)
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I love British Food"]];

}

- (void)test_USuggestionFeedback_ShouldRepeatFHSuggestionByUsingDifferentTypesOfSuggestionFeedbacks {
    CLLocation *location = [CLLocation new];
    [self.tokenRandomizerStub injectDontDo:@"FH:Comment"];

    // 1. branch (FH:SuggestionAsFollowUp)
    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants proposal] index:1];
    [self sendInput:[USuggestionFeedbackForTooFarAway createUtterance:[[RestaurantBuilder alloc] build] currentUserLocation:location text:@""]];
    [super assertLastStatementIs:@"FH:SuggestionAsFollowUp=King's Head, Norwich" state:@"askForSuggestionFeedback"];

    [self sendInput:[USuggestionFeedbackForTooExpensive createUtterance:[[[RestaurantBuilder alloc] withPriceLevel:4] build] currentUserLocation:location text:@""]];
    [super assertLastStatementIs:@"FH:SuggestionAsFollowUp=King's Head, Norwich" state:@"askForSuggestionFeedback"];

    // 1. branch (FH:Suggestion)
    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants proposal] index:0];
    [self sendInput:[USuggestionFeedbackForTooFarAway createUtterance:[[RestaurantBuilder alloc] build] currentUserLocation:location text:@""]];
    [super assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];

    // 2. branch (FH:SuggestionWithComment)
    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants proposal] index:2];
    [self sendInput:[USuggestionFeedbackForTooFarAway createUtterance:[[RestaurantBuilder alloc] build] currentUserLocation:location text:@""]];
    [super assertLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeCloser=King's Head, Norwich;FH:Confirmation" state:@"askForSuggestionFeedback"];
   }

- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenUSuggestionFeedbackForNotLikingAtAllAndFHSuggestionAsFollowUp {
    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants proposal] index:1];

    [self sendInput:[USuggestionFeedbackForNotLikingAtAll createUtterance:[[RestaurantBuilder alloc] build] currentUserLocation:_london text:@"I don't like that restaurant"]];

    [super assertLastStatementIs:@"FH:SuggestionAsFollowUp=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenUSuggestionFeedbackForNotLikingAtAllAndFHSuggestionWithComment {
    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants proposal] index:2];

    [self sendInput:[USuggestionFeedbackForNotLikingAtAll createUtterance:[[RestaurantBuilder alloc] build] currentUserLocation:_london text:@"I don't like that restaurant"]];

    [super assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenUSuggestionFeedbackForNotLikingAtAllAndFHSuggestion {
    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants proposal] index:0];

    [self sendInput:[USuggestionFeedbackForNotLikingAtAll createUtterance:[[RestaurantBuilder alloc] build] currentUserLocation:_london text:@"I don't like that restaurant"]];

    [super assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHWarningIfNotInPreferredRangeTooCheapAndFHSuggestionAfterWarning_WhenFoundRestaurantIsTooCheap {

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];
    Restaurant *onlyOtherOption = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Chippy"] build];
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *service) {
        [service injectFindResults:@[onlyOtherOption]];
    }];

    [self sendInput:[USuggestionFeedbackForTooCheap createUtterance:restaurant currentUserLocation:_london text:@"It looks too cheap"]];

    [super assertLastStatementIs:@"FH:WarningIfNotInPreferredRangeTooCheap;FH:SuggestionAfterWarning=Chippy, 18 Cathedral Street, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_USuggestionFeedback_ShouldNotTriggerFHWarningIfNotInPreferredRangeTooCheap_WhenUserHasAlreadyBeenWarnedBefore {

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];
    Restaurant *otherOption1 = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Chippy"] build];
    Restaurant *otherOption2 = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Hot cook"] build];
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *service) {
        [service injectFindResults:@[otherOption1, otherOption2]];
    }];

    [self sendInput:[USuggestionFeedbackForTooCheap createUtterance:restaurant currentUserLocation:_london text:@"It looks too cheap"]]; // User is going to be warned with FH:WarningIfNotInPreferredRangeTooCheap"
    [self sendInput:[USuggestionFeedbackForNotLikingAtAll createUtterance:otherOption1 currentUserLocation:_london text:@"I don't like that restaurant"]];

    [super assertLastStatementIs:@"FH:Suggestion=Hot cook, 18 Cathedral Street, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHWarningIfNotInPreferredRangeTooExpensiveAndFHSuggestionAfterWarning_WhenFoundRestaurantIsTooExpensive {
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];
    Restaurant *onlyOtherOption = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Chippy"] build];
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *service) {
        [service injectFindResults:@[onlyOtherOption]];
    }];

    [self sendInput:[USuggestionFeedbackForTooExpensive createUtterance:restaurant currentUserLocation:_london text:@""]];

    [super assertLastStatementIs:@"FH:WarningIfNotInPreferredRangeTooExpensive;FH:SuggestionAfterWarning=Chippy, 18 Cathedral Street, Norwich" state:@"askForSuggestionFeedback"];
}

- (void)test_USuggestionFeedback_ShouldNotTriggerFHWarningIfNotInPreferredRangeTooExpensive_WhenUserHasAlreadyBeenWarnedBefore {

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];
    Restaurant *otherOption1 = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Chippy"] build];
    Restaurant *otherOption2 = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Hot cook"] build];
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *service) {
        [service injectFindResults:@[otherOption1, otherOption2]];
    }];

    [self sendInput:[USuggestionFeedbackForTooExpensive createUtterance:restaurant currentUserLocation:_london text:@""]]; // User is going to be warned with FH:WarningIfNotInPreferredRangeTooExpensive
    [self sendInput:[USuggestionFeedbackForNotLikingAtAll createUtterance:otherOption1 currentUserLocation:_london text:@"I don't like that restaurant"]];

    [super assertLastStatementIs:@"FH:Suggestion=Hot cook, 18 Cathedral Street, Norwich" state:@"askForSuggestionFeedback"];
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

    [self sendInput:[USuggestionFeedbackForTooFarAway createUtterance:restaurant currentUserLocation:userLocation text:@""]];

    [super assertLastStatementIs:@"FH:SuggestionAfterWarning=Chippy, 18 Cathedral Street, Norwich" state:@"askForSuggestionFeedback"];
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

    [self sendInput:[USuggestionFeedbackForTooFarAway createUtterance:restaurant currentUserLocation:userLocation text:@""]];       // User is going to be warned with FH:WarningIfNotInPreferredRangeTooFarAway
    [self sendInput:[USuggestionFeedbackForNotLikingAtAll createUtterance:otherOption1 currentUserLocation:_london text:@"I don't like that restaurant"]];

    [super assertLastStatementIs:@"FH:Suggestion=Hot cook, 18 Cathedral Street, Norwich" state:@"askForSuggestionFeedback"];
}

@end