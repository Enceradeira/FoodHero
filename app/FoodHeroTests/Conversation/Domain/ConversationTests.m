//
//  ConversationTests.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "Conversation.h"
#import "Personas.h"
#import "DesignByContractException.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponents.h"
#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "AskUserToTryAgainAction.h"
#import "AskUserCuisinePreferenceAction.h"
#import "USuggestionNegativeFeedback.h"
#import "ConversationTestsBase.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "AlternationRandomizerStub.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "USuggestionFeedbackForLiking.h"
#import "HCIsExceptionOfType.h"
#import "RestaurantBuilder.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "SearchParameter.h"


@interface ConversationTests : ConversationTestsBase
@end

@implementation ConversationTests {
}

- (void)test_statementIndexes_ShouldStreamNewlyAddedStatements {
    NSMutableArray *receivedIndexes = [NSMutableArray new];
    [[self.conversation statementIndexes] subscribeNext:^(id next) {
        [receivedIndexes addObject:next];
    }];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]]; // adds the answer & food-heros response

    assertThat(receivedIndexes, contains(@0, @1, @2, nil));
}


- (void)test_getStatement_ShouldHaveFoodHerosGreeting_WhenAskedForFirst {
    Statement *statement = [self.conversation getStatement:0];

    assertThat(statement, is(notNilValue()));
    assertThat(statement.semanticId, is(equalTo(@"FH:Greeting&FH:OpeningQuestion")));
    assertThat(statement.persona, is(equalTo(Personas.foodHero)));
    assertThat(statement.inputAction.class, is(equalTo([AskUserCuisinePreferenceAction class])));
}

- (void)test_getStatement_ShouldReturnException_WhenUserHasNeverSaidAnythingAndWhenAskedForSecondStatement {
    @try {
        [self.conversation getStatement:1];
        XCTFail(@"An exception must be thrown");
    }
    @catch (DesignByContractException *exception) {
    }
}

- (void)test_getStatement_ShouldReturnUserAnswer_WhenUserHasSaidSomething {
    [self.conversation addToken:[UCuisinePreference create:@"British or Indian Food"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=British or Indian Food" userAction:nil];
}

- (void)test_getStatementCount_ShouldReturnNrOfStatementsInConversation {
    assertThatInteger([self.conversation getStatementCount], is(equalToInteger(1)));

    [self.conversation addToken:[UCuisinePreference create:@"British or Indian Food"]];
    assertThatInteger([self.conversation getStatementCount], is(equalToInteger(3)));
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithSuggestion {
    [self restaurantSearchReturnsName:@"King's Head" vicinity:@"Great Yarmouth"];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Great Yarmouth" userAction:[AskUserSuggestionFeedbackAction class]];
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithNoRestaurantsFound_WhenRestaurantServicesYieldsNoResults {
    [self.restaurantSearchStub injectFindNothing];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self assertLastStatementIs:@"FH:NoRestaurantsFound" userAction:[AskUserToTryAgainAction class]];
}

- (void)test_USuggestionFeedback_ShouldCauseFoodHeroToSearchAgain {
    [self.tokenRandomizerStub injectDontDo:@"FH:Comment"];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self restaurantSearchReturnsName:@"Lion Heart" vicinity:@"Great Yarmouth"];
    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:[[RestaurantBuilder alloc] build]]];

    [self assertLastStatementIs:@"FH:Suggestion=Lion Heart, Great Yarmouth" userAction:[AskUserSuggestionFeedbackAction class]];
}

- (void)test_negativeUserFeedback_ShouldReturnAllNegativeSuggestionFeedback {
    USuggestionNegativeFeedback *feedback1 = [USuggestionFeedbackForTooExpensive create:[[RestaurantBuilder alloc] build]];
    USuggestionNegativeFeedback *feedback2 = [USuggestionFeedbackForTooFarAway create:[[RestaurantBuilder alloc] build]];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:feedback1];
    [self.conversation addToken:feedback2];

    NSArray *feedback = [self.conversation negativeUserFeedback];
    assertThatUnsignedInt(feedback.count, is(equalToUnsignedInt(2)));
    assertThat(feedback, hasItem(feedback1));
    assertThat(feedback, hasItem(feedback2));
}

- (void)test_negativeUserFeedback_ShouldBeEmpty_WhenUserHasOnlyGivenPositiveFeedback {
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedbackForLiking create:[[RestaurantBuilder alloc] build]]];

    assertThatInteger(self.conversation.negativeUserFeedback.count, is(equalToInteger(0)));
}

- (void)test_negativeUserFeedback_ShouldBeEmpty_WhenFHHasNoRestaurantSuggestedYet {
    NSArray *restaurants = [self.conversation suggestedRestaurants];
    assertThat(restaurants, is(notNilValue()));
    assertThatInteger(restaurants.count, is(equalToInteger(0)));
}

- (void)test_suggestedRestaurants_ShouldNotBeEmpty_WhenFHHasSuggestedRestaurants {
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];  // 1. Restaurant suggested

    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionAsFollowUp"]; // make FH choose a different type of suggestion
    [self.conversation addToken:[USuggestionFeedbackForNotLikingAtAll create:[[RestaurantBuilder alloc] build]]]; // 2. Restaurant suggested

    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionWithComment"]; // make FH choose a different type of suggestion
    [self.conversation addToken:[USuggestionFeedbackForNotLikingAtAll create:[[RestaurantBuilder alloc] build]]]; // 3. Restaurant suggested
    NSArray *restaurants = [self.conversation suggestedRestaurants];
    assertThatInteger(restaurants.count, is(equalToInteger(3)));
}

- (void)test_cuisine_ShouldThrowException_WhenUserHasNotSpecifiedCuisineYet {
    assertThat(^() {
        self.conversation.currentSearchProfile.cuisine;
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_cuisine_ShouldReturnCuisine_WhenUserHasAlreadySpecifiedCuisine {
    [self.conversation addToken:[UCuisinePreference create:@"Asian, Swiss"]];

    assertThat(self.conversation.currentSearchProfile.cuisine, is(equalTo(@"Asian, Swiss")));
}

- (void)test_priceLevel_ShouldBeFullRange_WhenUserHasNotCommentedOnPriceYet {
    [self.conversation addToken:[UCuisinePreference create:@"Sandwich"]];

    PriceLevelRange *fullPriceRange = [PriceLevelRange createFullRange];

    assertThat(self.conversation.currentSearchProfile.priceRange, is(equalTo(fullPriceRange)));
}

- (void)test_priceLevel_ShouldDecreasePriceLevel_WhenUserFindsRestaurantTooExpensive {
    NSUInteger priceLevel = 3;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:restaurant]];

    assertThatUnsignedInt(self.conversation.currentSearchProfile.priceRange.max, is(equalTo(@(priceLevel - 1))));
}

- (void)test_priceLevel_ShouldIncreasePriceLevel_WhenUserFindsRestaurantTooCheap {
    NSUInteger priceLevel = 3;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:restaurant]];

    assertThatUnsignedInt(self.conversation.currentSearchProfile.priceRange.min, is(equalTo(@(priceLevel + 1))));
}

@end