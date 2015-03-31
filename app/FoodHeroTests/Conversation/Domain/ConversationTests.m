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
#import "ConversationTestsBase.h"
#import "HCIsExceptionOfType.h"
#import "RestaurantBuilder.h"


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

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I Like British Food"]]; // adds the answer & food-heros response

    assertThat(receivedIndexes, contains(@0, @1, @2, nil));
}


- (void)test_getStatement_ShouldHaveFoodHerosGreeting_WhenAskedForFirst {
    Statement *statement = [self.conversation getStatement:0];

    assertThat(statement, is(notNilValue()));
    assertThat(statement.semanticId, is(equalTo(@"FH:Greeting;FH:OpeningQuestion")));
    assertThat(statement.persona, is(equalTo(Personas.foodHero)));
    assertThat(statement.state, is(equalTo([FHStates askForFoodPreference])));
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
    [self sendInput:[UserUtterances cuisinePreference:@"British or Indian Food" text:@"I like British or Indian Food"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=British or Indian Food" state:nil];
}

- (void)test_getStatementCount_ShouldReturnNrOfStatementsInConversation {
    assertThatInteger([self.conversation getStatementCount], is(equalToInteger(1)));

    [self sendInput:[UserUtterances cuisinePreference:@"British or Indian Food" text:@"I like British or Indian Food"]];
    assertThatInteger([self.conversation getStatementCount], is(equalToInteger(3)));
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithSuggestion {
    Restaurant *kingsHead = [[[RestaurantBuilder alloc] withName:@"King's Head"] withVicinity:@"Great Yarmouth"].build;
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindResults:@[kingsHead]];
    }];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Great Yarmouth" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithNoRestaurantsFound_WhenRestaurantServicesYieldsNoResults {
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindNothing];
    }];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like Briish Food"]];

    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:[FHStates noRestaurantWasFound]];
}


- (void)test_UCuisinePreference_ShouldResetConversation {
    Restaurant *kingsHead = [[[RestaurantBuilder alloc] withName:@"King's Head"] withVicinity:@"Great Yarmouth"].build;
    Restaurant *tajMahal = [[[RestaurantBuilder alloc] withName:@"Taj Mahal"] withVicinity:@"Great Yarmouth"].build;

    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindResults:@[kingsHead, tajMahal]];
    }];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForDislike:kingsHead text:@"I don't like that restaurant"]];
    [self sendInput:[UserUtterances suggestionFeedbackForLike:tajMahal text:@"I like it"]];
    [self sendInput:[UserUtterances wantsToSearchForAnotherRestaurant:@"Do it again"]];
    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];

    // King's head should be suggested again since we started another search
    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Great Yarmouth" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_USuggestionFeedback_ShouldCauseFoodHeroToSearchAgain {
    Restaurant *kingsHead = [[RestaurantBuilder alloc] withPriceLevel:4].build;
    Restaurant *lionHeart = [[[RestaurantBuilder alloc] withName:@"Lion Heart"] withVicinity:@"Great Yarmouth"].build;
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindResults:@[kingsHead, lionHeart]];
    }];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];

    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:kingsHead text:@""]];

    [self assertLastStatementIs:@"FH:Suggestion=Lion Heart, Great Yarmouth" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_negativeUserFeedback_ShouldReturnAllNegativeSuggestionFeedback {
    Restaurant *restaurant1 = [[RestaurantBuilder alloc] build];
    Restaurant *restaurant2 = [[RestaurantBuilder alloc] build];
    [self configureRestaurantSearchForLocation:_london configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindResults:@[restaurant1, restaurant2]];
    }];

    TalkerUtterance *feedback1 = [UserUtterances suggestionFeedbackForTooExpensive:restaurant1 text:@""];
    TalkerUtterance *feedback2 = [UserUtterances suggestionFeedbackForTooFarAway:restaurant2 text:@""];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];
    [self sendInput:feedback1];
    [self sendInput:feedback2];

    NSArray *feedback = [self.conversation negativeUserFeedback];
    assertThatUnsignedInt(feedback.count, is(equalToUnsignedInt(2)));
    USuggestionFeedbackParameters *parameter1 = feedback[0];
    USuggestionFeedbackParameters *parameter2 = feedback[1];
    assertThat(parameter1.restaurant, is(equalTo(restaurant1)));
    assertThat(parameter1.semanticIdInclParameters, is(equalTo(@"U:SuggestionFeedback=tooExpensive")));
    assertThat(parameter2.restaurant, is(equalTo(restaurant2)));
    assertThat(parameter2.semanticIdInclParameters, is(equalTo(@"U:SuggestionFeedback=tooFarAway")));
}

- (void)test_negativeUserFeedback_ShouldBeEmpty_WhenUserHasOnlyGivenPositiveFeedback {
    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForLike:[[RestaurantBuilder alloc] build] text:@"I like it"]];

    assertThatInteger(self.conversation.negativeUserFeedback.count, is(equalToInteger(0)));
}

- (void)test_negativeUserFeedback_ShouldBeEmpty_WhenFHHasNoRestaurantSuggestedYet {
    NSArray *restaurants = [self.conversation suggestedRestaurants];
    assertThat(restaurants, is(notNilValue()));
    assertThatInteger(restaurants.count, is(equalToInteger(0)));
}

- (void)test_suggestedRestaurants_ShouldNotBeEmpty_WhenFHHasSuggestedRestaurants {
    Restaurant *restaurant1 = [[RestaurantBuilder alloc] build];
    Restaurant *restaurant2 = [[RestaurantBuilder alloc] build];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];  // 1. Restaurant suggested

    [self sendInput:[UserUtterances suggestionFeedbackForDislike:restaurant1 text:@"I don't like that restaurant"]]; // 2. Restaurant suggested

    [self sendInput:[UserUtterances suggestionFeedbackForDislike:restaurant2 text:@"I don't like that restaurant"]]; // 3. Restaurant suggested
    NSArray *restaurants = [self.conversation suggestedRestaurants];
    assertThatInteger(restaurants.count, is(equalToInteger(3)));
}

- (void)test_currentSearchPreferenceCuisine_ShouldThrowException_WhenUserHasNotSpecifiedCuisineYet {
    assertThat(^() {
        [[self conversation] currentSearchPreference:0 currUserLocation:_london];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_currentSearchPreferenceCuisine_ShouldReturnCuisine_WhenUserHasAlreadySpecifiedCuisine {
    [self sendInput:[UserUtterances cuisinePreference:@"Asian, Swiss" text:@"Asian, Swiss"]];

    assertThat([self.conversation currentSearchPreference:0 currUserLocation:_london].cuisine, is(equalTo(@"Asian, Swiss")));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldBeFullRange_WhenUserHasNotCommentedOnPriceYet {
    [self sendInput:[UserUtterances cuisinePreference:@"Sandwich" text:@"I love Sandwich"]];

    PriceRange *fullPriceRange = [PriceRange priceRangeWithoutRestriction];

    assertThat([self.conversation currentSearchPreference:0 currUserLocation:_london].priceRange, is(equalTo(fullPriceRange)));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldDecreasePriceLevel_WhenUserFindsRestaurantTooExpensive {
    NSUInteger priceLevel = 3;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:restaurant text:@""]];

    assertThatUnsignedInt([self.conversation currentSearchPreference:0 currUserLocation:_london].priceRange.max, is(equalTo(@(priceLevel - 1))));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldNotDecreasePriceLevel_WhenUserFindsRestaurantTooExpensiveButItsAlreadyTheCheapestPossible {
    NSUInteger priceLevel = GOOGLE_PRICE_LEVEL_MIN;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:restaurant text:@"It's far too expensive"]];

    assertThatUnsignedInt([self.conversation currentSearchPreference:0 currUserLocation:_london].priceRange.max, is(equalTo(@(GOOGLE_PRICE_LEVEL_MIN))));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldIncreasePriceLevel_WhenUserFindsRestaurantTooCheap {
    NSUInteger priceLevel = 3;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:restaurant text:@"It looks too cheap"]];

    assertThatUnsignedInt([self.conversation currentSearchPreference:0 currUserLocation:_norwich].priceRange.min, is(equalTo(@(priceLevel + 1))));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldNotIncreasePriceLevel_WhenUserFindsRestaurantTooCheapButItsAlreadyTheMostExpensivePossible {
    NSUInteger priceLevel = GOOGLE_PRICE_LEVEL_MAX;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:restaurant text:@"It looks too cheap"]];

    assertThatUnsignedInt([self.conversation currentSearchPreference:0 currUserLocation:_norwich].priceRange.min, is(equalTo(@(GOOGLE_PRICE_LEVEL_MAX))));
}

- (void)test_currentSearchPreferenceMaxDistance_ShouldDecrease_WhenUserFindRestaurantTooFarAway {
    CLLocationDistance distance = [_norwich distanceFromLocation:_london];

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withLocation:_norwich] build];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooFarAway:restaurant text:@"It's too far away"]];

    assertThatDouble([self.conversation currentSearchPreference:distance currUserLocation:_london].distanceRange.max, is(lessThan(@(distance))));
}

- (void)test_currentSearchPreferenceDistanceRangeShouldBeNil_WhenUserHasNotYetGivenFeedbackRelatedToDistance {
    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];

    DistanceRange *distanceRange = [self.conversation currentSearchPreference:15688 currUserLocation:_london].distanceRange;
    assertThat(distanceRange, is(nilValue()));
}

- (void)test_lastSuggestionWarning_ShouldReturnNil_WhenNoSuggestionWarningExists {
    assertThat([self.conversation lastSuggestionWarning], is(nilValue()));
}

- (void)test_lastSuggestionWarning_ShouldReturnLastSuggestionWarning {
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:restaurant text:@"It looks too cheap"]];

    ConversationParameters *lastSuggestionWarning = [self.conversation lastSuggestionWarning];
    assertThat(lastSuggestionWarning, is(notNilValue()));
    assertThatBool([lastSuggestionWarning hasSemanticId:@"FH:WarningIfNotInPreferredRangeTooCheap"], isTrue());
}

- (void)test_statementIndexes_ShouldYieldGreetingAndOpeningQuestion {
    __block NSInteger nrIndexes = 0;
    RACSignal *signal = [self.conversation statementIndexes];
    [signal subscribeNext:^(id next) {
        nrIndexes++;
    }];

    assertThatInteger(nrIndexes, is(equalTo(@(1))));
}

- (void)test_lastUserResponse_ShouldReturnLastUserUtterance {
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withLocation:_norwich] build];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForLike:restaurant text:@"Looks cool"]];

    ConversationParameters *lastResponse = [self.conversation lastUserResponse];
    assertThat(lastResponse, isNot(nilValue()));
    assertThatBool([lastResponse hasSemanticId:@"U:SuggestionFeedback=Like"], isTrue());
}

- (void)test_lastUserResponse_ShouldIgnoreUtterancesFromPreviousSearch {
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withLocation:_norwich] build];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForDislike:restaurant text:@"I don't like that restaurant"]];
    [self sendInput:[UserUtterances suggestionFeedbackForLike:restaurant text:@"I like it"]];
    [self sendInput:[UserUtterances wantsToSearchForAnotherRestaurant:@"Do it again"]];

    ConversationParameters *lastResponse = [self.conversation lastUserResponse];
    assertThat(lastResponse, is(nilValue()));
}

- (void)test_lastUserResponse_ShouldReturnNil_WhenUserHasSaidNothing {
    ConversationParameters *lastResponse = [self.conversation lastUserResponse];
    assertThat(lastResponse, is(nilValue()));
}

@end