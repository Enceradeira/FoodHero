//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "RandomizerStub.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "RestaurantBuilder.h"

@interface ConversationFirstProposalTests : ConversationTestsBase
@end

@implementation ConversationFirstProposalTests {

}

- (void)setUp {
    [super setUp];

    [self.tokenRandomizerStub injectDontDo:@"FH:Comment"];
}


- (void)test_USuggestionFeedback_ShouldAddUserStatement {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    [self.conversation addFHToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];
    [self.conversation addFHToken:[USuggestionFeedbackForTooCheap create:cheapRestaurant text:@"It looks too cheap"]];

    [self assertSecondLastStatementIs:@"U:SuggestionFeedback=tooCheap" userAction:nil];
}


- (void)test_USuggestionFeedback_ShouldTriggerFHSuggestion_WhenRandomizerWouldChooseFHSuggestionAsFollowUp {
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionAsFollowUp"];

    [self.conversation addFHToken:[UCuisinePreference create:@"British Food" text:@"I love British Food"]];

    // Because it's the first suggestion, FHSuggestionAsFollowUp is not a valid option
    [super assertLastStatementIs:@"FH:Suggestion=King's Head, Norwich" userAction:AskUserSuggestionFeedbackAction.class];
}

@end