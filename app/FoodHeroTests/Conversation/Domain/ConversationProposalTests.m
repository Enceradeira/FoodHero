//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "AlternationRandomizerStub.h"
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
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

}

- (void)test_USuggestionFeedback_ShouldRepeatFHSuggestionByUsingDifferentTypesOfSuggestionFeedbacks {
    CLLocation *location = [CLLocation new];
    [self.tokenRandomizerStub injectDontDo:@"FH:Comment"];

    // 1. branch (FH:SuggestionAsFollowUp)
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionAsFollowUp"];
    [self.conversation addToken:[USuggestionFeedbackForTooFarAway create:[[RestaurantBuilder alloc] build] currentUserLocation:location]];
    [super assertLastStatementIs:@"FH:SuggestionAsFollowUp=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];

    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:[[[RestaurantBuilder alloc] withPriceLevel:4] build]]];
    [super assertLastStatementIs:@"FH:SuggestionAsFollowUp=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];

    // 1. branch (FH:Suggestion)
    [self.tokenRandomizerStub injectChoice:@"FH:Suggestion"];
    [self.conversation addToken:[USuggestionFeedbackForTooFarAway create:[[RestaurantBuilder alloc] build] currentUserLocation:location]];
    [super assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];

    // 2. branch (FH:SuggestionWithComment)
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionWithComment"];
    [self.conversation addToken:[USuggestionFeedbackForTooFarAway create:[[RestaurantBuilder alloc] build] currentUserLocation:location]];
    [super assertSecondLastStatementIs:@"FH:SuggestionWithConfirmationIfInNewPreferredRangeCloser=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
    [super assertLastStatementIs:@"FH:Confirmation" userAction:nil];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenUSuggestionFeedbackForNotLikingAtAllAndFHSuggestionAsFollowUp {
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionAsFollowUp"];

    [self.conversation addToken:[USuggestionFeedbackForNotLikingAtAll create:[[RestaurantBuilder alloc] build]]];

    [super assertLastStatementIs:@"FH:SuggestionAsFollowUp=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenUSuggestionFeedbackForNotLikingAtAllAndFHSuggestionWithComment {
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionWithComment"];

    [self.conversation addToken:[USuggestionFeedbackForNotLikingAtAll create:[[RestaurantBuilder alloc] build]]];

    [super assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenUSuggestionFeedbackForNotLikingAtAllAndFHSuggestion {
    [self.tokenRandomizerStub injectChoice:@"FH:Suggestion"];

    [self.conversation addToken:[USuggestionFeedbackForNotLikingAtAll create:[[RestaurantBuilder alloc] build]]];

    [super assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHWarningIfNotInPreferredRanceAndFHSuggestionAfterWarning_WhenFoundRestaurantIsTooCheap {

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];
    Restaurant *onlyOtherOption = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Chippy"] build];
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *service) {
        [service injectFindResults:@[onlyOtherOption]];
    }];

    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:restaurant]];

    [super assertSecondLastStatementIs:@"FH:WarningIfNotInPreferredRangeTooCheap" userAction:nil];
    [super assertLastStatementIs:@"FH:SuggestionAfterWarning=Chippy, 18 Cathedral Street, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHWarningIfNotInPreferredRanceAndFHSuggestionAfterWarning_WhenFoundRestaurantIsTooExpensive {
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];
    Restaurant *onlyOtherOption = [[[[RestaurantBuilder alloc] withPriceLevel:3] withName:@"Chippy"] build];
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *service) {
        [service injectFindResults:@[onlyOtherOption]];
    }];

    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:restaurant]];

    [super assertSecondLastStatementIs:@"FH:WarningIfNotInPreferredRangeTooExpensive" userAction:nil];
    [super assertLastStatementIs:@"FH:SuggestionAfterWarning=Chippy, 18 Cathedral Street, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

- (void)test_USuggestionFeedback_ShouldTriggerFHWarningIfNotInPreferredRanceAndFHSuggestionAfterWarning_WhenFoundRestaurantIsTooFarAway {
    //assertThatBool(YES, is(equalToBool(NO)));
}

@end