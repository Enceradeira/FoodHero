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
#import "USuggestionNegativeFeedback.h"
#import "ConversationTestsBase.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "USuggestionFeedbackForLiking.h"
#import "HCIsExceptionOfType.h"
#import "RestaurantBuilder.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "SearchProfile.h"
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

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I Like British Food"]]; // adds the answer & food-heros response

    assertThat(receivedIndexes, contains(@0, @1, @2, nil));
}


- (void)test_getStatement_ShouldHaveFoodHerosGreeting_WhenAskedForFirst {
    Statement *statement = [self.conversation getStatement:0];

    assertThat(statement, is(notNilValue()));
    assertThat(statement.semanticId, is(equalTo(@"FH:Greeting;FH:OpeningQuestion")));
    assertThat(statement.persona, is(equalTo(Personas.foodHero)));
    assertThat(statement.state, is(equalTo(@"askForFoodPreference")));
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
    [self sendInput:[UCuisinePreference createUtterance:@"British or Indian Food" text:@"I like British or Indian Food"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=British or Indian Food" state:@""];
}

- (void)test_getStatementCount_ShouldReturnNrOfStatementsInConversation {
    assertThatInteger([self.conversation getStatementCount], is(equalToInteger(1)));

    [self sendInput:[UCuisinePreference createUtterance:@"British or Indian Food" text:@"I like British or Indian Food"]];
    assertThatInteger([self.conversation getStatementCount], is(equalToInteger(3)));
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithSuggestion {
    Restaurant *kingsHead = [[[RestaurantBuilder alloc] withName:@"King's Head"] withVicinity:@"Great Yarmouth"].build;
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindResults:@[kingsHead]];
    }];

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Great Yarmouth" state:@"askForSuggestionFeedback"];
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithNoRestaurantsFound_WhenRestaurantServicesYieldsNoResults {
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like Briish Food"]];

    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:@"noRestaurantWasFound"];
}


- (void)test_UCuisinePreference_ShouldResetConversation {
    Restaurant *kingsHead = [[[RestaurantBuilder alloc] withName:@"King's Head"] withVicinity:@"Great Yarmouth"].build;
    Restaurant *tajMahal = [[[RestaurantBuilder alloc] withName:@"Taj Mahal"] withVicinity:@"Great Yarmouth"].build;

    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindResults:@[kingsHead, tajMahal]];
    }];

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];
    [self sendInput:[USuggestionFeedbackForNotLikingAtAll createUtterance:kingsHead text:@"I don't like that restaurant"]];
    [self sendInput:[USuggestionFeedbackForLiking createUtterance:tajMahal text:@"I like it"]];
    [self sendInput:[UWantsToSearchForAnotherRestaurant createUtterance:@"Do it again"]];
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];

    // King's head should be suggested again since we started another search
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Great Yarmouth" state:@"askForSuggestionFeedback"];
}

- (void)test_USuggestionFeedback_ShouldCauseFoodHeroToSearchAgain {
    Restaurant *kingsHead = [[RestaurantBuilder alloc] withPriceLevel:4].build;
    Restaurant *lionHeart = [[[RestaurantBuilder alloc] withName:@"Lion Heart"] withVicinity:@"Great Yarmouth"].build;
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindResults:@[kingsHead, lionHeart]];
    }];

    [self.tokenRandomizerStub injectDontDo:@"FH:Comment"];

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];

    [self sendInput:[USuggestionFeedbackForTooExpensive createUtterance:kingsHead text:nil]];

    [self assertLastStatementIs:@"FH:Suggestion=Lion Heart, Great Yarmouth" state:@"askForSuggestionFeedback"];
}

- (void)test_negativeUserFeedback_ShouldReturnAllNegativeSuggestionFeedback {
    TalkerUtterance *feedback1 = [USuggestionFeedbackForTooExpensive createUtterance:[[RestaurantBuilder alloc] build] text:nil];
    TalkerUtterance *feedback2 = [USuggestionFeedbackForTooFarAway createUtterance:[[RestaurantBuilder alloc] build] currentUserLocation:[CLLocation new] text:nil];

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];
    [self sendInput:feedback1];
    [self sendInput:feedback2];

    NSArray *feedback = [self.conversation negativeUserFeedback];
    assertThatUnsignedInt(feedback.count, is(equalToUnsignedInt(2)));
    assertThat(feedback, hasItem(feedback1));
    assertThat(feedback, hasItem(feedback2));
}

- (void)test_negativeUserFeedback_ShouldBeEmpty_WhenUserHasOnlyGivenPositiveFeedback {
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];
    [self sendInput:[USuggestionFeedbackForLiking create:[[RestaurantBuilder alloc] build] text:@"I like it"]];

    assertThatInteger(self.conversation.negativeUserFeedback.count, is(equalToInteger(0)));
}

- (void)test_negativeUserFeedback_ShouldBeEmpty_WhenFHHasNoRestaurantSuggestedYet {
    NSArray *restaurants = [self.conversation suggestedRestaurants];
    assertThat(restaurants, is(notNilValue()));
    assertThatInteger(restaurants.count, is(equalToInteger(0)));
}

- (void)test_suggestedRestaurants_ShouldNotBeEmpty_WhenFHHasSuggestedRestaurants {
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];  // 1. Restaurant suggested

    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionAsFollowUp"]; // make FH choose a different type of suggestion
    [self sendInput:[USuggestionFeedbackForNotLikingAtAll createUtterance:[[RestaurantBuilder alloc] build] text:@"I don't like that restaurant"]]; // 2. Restaurant suggested

    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionWithComment"]; // make FH choose a different type of suggestion
    [self sendInput:[USuggestionFeedbackForNotLikingAtAll createUtterance:[[RestaurantBuilder alloc] build] text:@"I don't like that restaurant"]]; // 3. Restaurant suggested
    NSArray *restaurants = [self.conversation suggestedRestaurants];
    assertThatInteger(restaurants.count, is(equalToInteger(3)));
}

- (void)test_currentSearchPreferenceCuisine_ShouldThrowException_WhenUserHasNotSpecifiedCuisineYet {
    assertThat(^() {
        [[self conversation] currentSearchPreference];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_currentSearchPreferenceCuisine_ShouldReturnCuisine_WhenUserHasAlreadySpecifiedCuisine {
    [self sendInput:[UCuisinePreference createUtterance:@"Asian, Swiss" text:@"Asian, Swiss"]];

    assertThat(self.conversation.currentSearchPreference.cuisine, is(equalTo(@"Asian, Swiss")));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldBeFullRange_WhenUserHasNotCommentedOnPriceYet {
    [self sendInput:[UCuisinePreference createUtterance:@"Sandwich" text:@"I love Sandwich"]];

    PriceRange *fullPriceRange = [PriceRange priceRangeWithoutRestriction];

    assertThat(self.conversation.currentSearchPreference.priceRange, is(equalTo(fullPriceRange)));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldDecreasePriceLevel_WhenUserFindsRestaurantTooExpensive {
    NSUInteger priceLevel = 3;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];
    [self sendInput:[USuggestionFeedbackForTooExpensive createUtterance:restaurant text:nil]];

    assertThatUnsignedInt(self.conversation.currentSearchPreference.priceRange.max, is(equalTo(@(priceLevel - 1))));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldNotDecreasePriceLevel_WhenUserFindsRestaurantTooExpensiveButItsAlreadyTheCheapestPossible {
    NSUInteger priceLevel = GOOGLE_PRICE_LEVEL_MIN;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];
    [self sendInput:[USuggestionFeedbackForTooExpensive createUtterance:restaurant text:nil]];

    assertThatUnsignedInt(self.conversation.currentSearchPreference.priceRange.max, is(equalTo(@(GOOGLE_PRICE_LEVEL_MIN))));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldIncreasePriceLevel_WhenUserFindsRestaurantTooCheap {
    NSUInteger priceLevel = 3;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];
    [self sendInput:[USuggestionFeedbackForTooCheap createUtterance:restaurant text:@"It looks too cheap"]];

    assertThatUnsignedInt(self.conversation.currentSearchPreference.priceRange.min, is(equalTo(@(priceLevel + 1))));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldNotIncreasePriceLevel_WhenUserFindsRestaurantTooCheapButItsAlreadyTheMostExpensivePossible {
    NSUInteger priceLevel = GOOGLE_PRICE_LEVEL_MAX;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];
    [self sendInput:[USuggestionFeedbackForTooCheap createUtterance:restaurant text:@"It looks too cheap"]];

    assertThatUnsignedInt(self.conversation.currentSearchPreference.priceRange.min, is(equalTo(@(GOOGLE_PRICE_LEVEL_MAX))));
}

- (void)test_currentSearchPreferenceMaxDistance_ShouldHaveMaxValue_WhenUserHasNeverFoundRestaurantTooFarAway {
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];

    assertThatDouble(self.conversation.currentSearchPreference.distanceRange.max, is(equalTo(@(DBL_MAX))));
}

- (void)test_currentSearchPreferenceMaxDistance_ShouldDecrease_WhenUserFindRestaurantTooFarAway {
    CLLocationDistance distance = [_norwich distanceFromLocation:_london];

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withLocation:_norwich] build];

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];
    [self sendInput:[USuggestionFeedbackForTooFarAway createUtterance:restaurant currentUserLocation:_london text:@"It's too far away"]];

    assertThatDouble(self.conversation.currentSearchPreference.distanceRange.max, is(lessThan(@(distance))));
}

- (void)test_lastSuggestionWarning_ShouldReturnNil_WhenNoSuggestionWarningExists {
    assertThat([self.conversation lastSuggestionWarning], is(nilValue()));
}

- (void)test_lastSuggestionWarning_ShouldReturnLastSuggestionWarning {
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];
    [FHWarningIfNotInPreferredRangeTooCheap create];

    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I like British Food"]];
    [self sendInput:[USuggestionFeedbackForTooCheap createUtterance:restaurant text:@"It looks too cheap"]];

    ConversationToken *lastSuggestionWarning = [self.conversation lastSuggestionWarning];
    assertThat(lastSuggestionWarning, is(notNilValue()));
    assertThat(lastSuggestionWarning.class, is(equalTo([FHWarningIfNotInPreferredRangeTooCheap class])));
}

- (void)test_statementIndexes_ShouldYieldGreetingAndOpeningQuestion {
    __block NSInteger nrIndexes = 0;
    RACSignal *signal = [self.conversation statementIndexes];
    [signal subscribeNext:^(id next) {
        nrIndexes++;
    }];

    assertThatInteger(nrIndexes, is(equalTo(@(1))));
}

@end