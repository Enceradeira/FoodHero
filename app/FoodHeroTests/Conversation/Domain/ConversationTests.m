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
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "USuggestionFeedbackForLiking.h"
#import "HCIsExceptionOfType.h"
#import "RestaurantBuilder.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "SearchProfil.h"
#import "FHWarningIfNotInPreferredRangeTooCheap.h"
#import "UWantsToSearchForAnotherRestaurant.h"


@interface ConversationTests : ConversationTestsBase
@end

@implementation ConversationTests {
    CLLocation *_norwich;
    CLLocation *_london;
}

- (void)setUp {
    [super setUp];

    _norwich = [[CLLocation alloc] initWithLatitude:52.631944 longitude:1.298889];
    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];
}


- (void)test_statementIndexes_ShouldStreamNewlyAddedStatements {
    NSMutableArray *receivedIndexes = [NSMutableArray new];
    RACSignal *signal = [self.conversation statementIndexes];
    [signal subscribeNext:^(id next) {
        [receivedIndexes addObject:next];
    }];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]]; // adds the answer & food-heros response

    assertThat(receivedIndexes, contains(@0, @1, @2, @3, nil));
}


- (void)test_getStatement_ShouldHaveFoodHerosGreeting_WhenAskedForFirst {
    Statement *statement = [self.conversation getStatement:0];

    assertThat(statement, is(notNilValue()));
    assertThat(statement.semanticId, is(equalTo(@"FH:Greeting")));
    assertThat(statement.persona, is(equalTo(Personas.foodHero)));
    assertThat(statement.inputAction.class, is(nilValue()));
}

- (void)test_getStatement_ShouldReturnException_WhenUserHasNeverSaidAnythingAndWhenAskedForThirdStatement {
    @try {
        [self.conversation getStatement:2];
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
    assertThatInteger([self.conversation getStatementCount], is(equalToInteger(2)));

    [self.conversation addToken:[UCuisinePreference create:@"British or Indian Food"]];
    assertThatInteger([self.conversation getStatementCount], is(equalToInteger(4)));
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithSuggestion {
    Restaurant *kingsHead = [[[RestaurantBuilder alloc] withName:@"King's Head"] withVicinity:@"Great Yarmouth"].build;
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindResults:@[kingsHead]];
    }];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Great Yarmouth" userAction:[AskUserSuggestionFeedbackAction class]];
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithNoRestaurantsFound_WhenRestaurantServicesYieldsNoResults {
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self assertLastStatementIs:@"FH:NoRestaurantsFound" userAction:[AskUserToTryAgainAction class]];
}


- (void)test_UCuisinePreference_ShouldResetConversation {
    Restaurant *kingsHead = [[[RestaurantBuilder alloc] withName:@"King's Head"] withVicinity:@"Great Yarmouth"].build;
    Restaurant *tajMahal = [[[RestaurantBuilder alloc] withName:@"Taj Mahal"] withVicinity:@"Great Yarmouth"].build;

    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindResults:@[kingsHead, tajMahal]];
    }];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedbackForNotLikingAtAll create:kingsHead]];
    [self.conversation addToken:[USuggestionFeedbackForLiking create:tajMahal]];
    [self.conversation addToken:[UWantsToSearchForAnotherRestaurant new]];
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    // King's head should be suggested again since we started another search
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Great Yarmouth" userAction:[AskUserSuggestionFeedbackAction class]];
}

- (void)test_USuggestionFeedback_ShouldCauseFoodHeroToSearchAgain {
    Restaurant *kingsHead = [[RestaurantBuilder alloc] withPriceLevel:4].build;
    Restaurant *lionHeart = [[[RestaurantBuilder alloc] withName:@"Lion Heart"] withVicinity:@"Great Yarmouth"].build;
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindResults:@[kingsHead, lionHeart]];
    }];

    [self.tokenRandomizerStub injectDontDo:@"FH:Comment"];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:kingsHead]];

    [self assertLastStatementIs:@"FH:Suggestion=Lion Heart, Great Yarmouth" userAction:[AskUserSuggestionFeedbackAction class]];
}

- (void)test_negativeUserFeedback_ShouldReturnAllNegativeSuggestionFeedback {
    USuggestionNegativeFeedback *feedback1 = [USuggestionFeedbackForTooExpensive create:[[RestaurantBuilder alloc] build]];
    USuggestionNegativeFeedback *feedback2 = [USuggestionFeedbackForTooFarAway create:[[RestaurantBuilder alloc] build] currentUserLocation:[CLLocation new]];

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

- (void)test_currentSearchPreferenceCuisine_ShouldThrowException_WhenUserHasNotSpecifiedCuisineYet {
    assertThat(^() {
        [[self conversation] currentSearchPreference];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_currentSearchPreferenceCuisine_ShouldReturnCuisine_WhenUserHasAlreadySpecifiedCuisine {
    [self.conversation addToken:[UCuisinePreference create:@"Asian, Swiss"]];

    assertThat(self.conversation.currentSearchPreference.cuisine, is(equalTo(@"Asian, Swiss")));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldBeFullRange_WhenUserHasNotCommentedOnPriceYet {
    [self.conversation addToken:[UCuisinePreference create:@"Sandwich"]];

    PriceRange *fullPriceRange = [PriceRange priceRangeWithoutRestriction];

    assertThat(self.conversation.currentSearchPreference.priceRange, is(equalTo(fullPriceRange)));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldDecreasePriceLevel_WhenUserFindsRestaurantTooExpensive {
    NSUInteger priceLevel = 3;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:restaurant]];

    assertThatUnsignedInt(self.conversation.currentSearchPreference.priceRange.max, is(equalTo(@(priceLevel - 1))));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldNotDecreasePriceLevel_WhenUserFindsRestaurantTooExpensiveButItsAlreadyTheCheapestPossible {
    NSUInteger priceLevel = GOOGLE_PRICE_LEVEL_MIN;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:restaurant]];

    assertThatUnsignedInt(self.conversation.currentSearchPreference.priceRange.max, is(equalTo(@(GOOGLE_PRICE_LEVEL_MIN))));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldIncreasePriceLevel_WhenUserFindsRestaurantTooCheap {
    NSUInteger priceLevel = 3;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:restaurant]];

    assertThatUnsignedInt(self.conversation.currentSearchPreference.priceRange.min, is(equalTo(@(priceLevel + 1))));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldNotIncreasePriceLevel_WhenUserFindsRestaurantTooCheapButItsAlreadyTheMostExpensivePossible {
    NSUInteger priceLevel = GOOGLE_PRICE_LEVEL_MAX;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:restaurant]];

    assertThatUnsignedInt(self.conversation.currentSearchPreference.priceRange.min, is(equalTo(@(GOOGLE_PRICE_LEVEL_MAX))));
}

- (void)test_currentSearchPreferenceMaxDistance_ShouldHaveMaxValue_WhenUserHasNeverFoundRestaurantTooFarAway {
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    assertThatDouble(self.conversation.currentSearchPreference.distanceRange.max, is(equalTo(@(DBL_MAX))));
}

- (void)test_currentSearchPreferenceMaxDistance_ShouldDecrease_WhenUserFindRestaurantTooFarAway {
    CLLocationDistance distance = [_norwich distanceFromLocation:_london];

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withLocation:_norwich] build];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedbackForTooFarAway create:restaurant currentUserLocation:_london]];

    assertThatDouble(self.conversation.currentSearchPreference.distanceRange.max, is(lessThan(@(distance))));
}

- (void)test_lastSuggestionWarning_ShouldReturnNil_WhenNoSuggestionWarningExists {
    assertThat([self.conversation lastSuggestionWarning], is(nilValue()));
}

- (void)test_lastSuggestionWarning_ShouldReturnLastSuggestionWarning {
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];
    [FHWarningIfNotInPreferredRangeTooCheap create];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:restaurant]];

    ConversationToken *lastSuggestionWarning = [self.conversation lastSuggestionWarning];
    assertThat(lastSuggestionWarning, is(notNilValue()));
    assertThat(lastSuggestionWarning.class, is(equalTo([FHWarningIfNotInPreferredRangeTooCheap class])));
}

- (void)test_FHGreeting_ShouldHaveTwoTemporallyDisconnectedParts_WhenFHNeedsCoffeeBeforeHeCanContinue {
    [self.textRepositoryStub injectGreeting:@"I’m tired.  I need coffee before I can continue."];

    [self resetConversation];

    assertThatUnsignedInt([self.conversation getStatementCount], is(equalTo(@(2))));
    [self assertSecondLastStatementIs:@"FH:Greeting" userAction:nil];
    [self assertLastStatementIs:@"FH:OpeningQuestion" userAction:[AskUserCuisinePreferenceAction class]];
}

-(void)test_statementIndexes_ShouldYieldGreetingAndOpeningQuestion{
    __block NSInteger nrIndexes = 0;
    RACSignal *signal = [self.conversation statementIndexes];
    [signal subscribeNext:^(id next) {
        nrIndexes++;
    }];

    assertThatInteger(nrIndexes, is(equalTo(@(2))));
}

@end