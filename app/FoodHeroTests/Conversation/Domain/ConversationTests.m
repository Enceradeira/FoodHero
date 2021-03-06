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
#import "ConversationTestsBase.h"
#import "RestaurantBuilder.h"
#import "FoodHeroTests-Swift.h"


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

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I Like British Food"]]; // adds the answer & food-heros response

    assertThat(receivedIndexes, contains(@0, @1, @2, @3, nil));
}


- (void)test_getStatement_ShouldHaveFoodHerosGreeting_WhenAskedForFirst {
    Statement *statement = [self.conversation getStatement:0];

    assertThat(statement, is(notNilValue()));
    assertThat(statement.semanticId, containsString(@"FH:Greeting"));
    assertThat(statement.persona, is(equalTo(Personas.foodHero)));
    assertThat(statement.state, is(nilValue()));
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
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British or Indian Food" location:nil] text:@"I like British or Indian Food"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=British or Indian Food" state:nil];
}

- (void)test_getStatementCount_ShouldReturnNrOfStatementsInConversation {
    assertThatInteger([self.conversation getStatementCount], is(equalToInteger(2)));

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British or Indian Food" location:nil] text:@"I like British or Indian Food"]];
    assertThatInteger([self.conversation getStatementCount], is(greaterThan(@2)));
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithSuggestion {
    Restaurant *kingsHead = [[[RestaurantBuilder alloc] withName:@"King's Head"] withVicinity:@"Great Yarmouth"].build;
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindResults:@[kingsHead]];
    }];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];

    [self assertLastStatementIs:@"FH:Suggestion=King's Head, Great Yarmouth" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithNoRestaurantsFound_WhenRestaurantServicesYieldsNoResults {
    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindNothing];
    }];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like Briish Food"]];

    [self assertLastStatementIs:@"FH:NoRestaurantsFound" state:[FHStates noRestaurantWasFound]];
}

- (void)test_USuggestionFeedback_ShouldCauseFoodHeroToSearchAgain {
    Restaurant *kingsHead = [[[RestaurantBuilder alloc] withName:@"Head of King"] withPriceLevel:4].build;
    Restaurant *lionHeart = [[[RestaurantBuilder alloc] withName:@"Lion Heart"] withVicinity:@"Great Yarmouth"].build;
    Restaurant *kingsbed = [[[RestaurantBuilder alloc] withName:@"Kings Bed"] withVicinity:@"Great Yarmouth"].build;

    [self configureRestaurantSearchForLatitude:12 longitude:12 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindResults:@[kingsHead, lionHeart, kingsbed]];
    }];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];

    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:kingsHead text:@""]];

    [self assertLastStatementIs:@"FH:Suggestion=Lion Heart, Great Yarmouth" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_negativeUserFeedback_ShouldReturnAllNegativeSuggestionFeedback {
    Restaurant *restaurant1 = [[RestaurantBuilder alloc] build];
    Restaurant *restaurant2 = [[RestaurantBuilder alloc] build];
    [self configureRestaurantSearchForLocation:_london configuration:^(PlacesAPIStub *stub) {
        [stub injectFindResults:@[restaurant1, restaurant2]];
    }];

    TalkerUtterance *feedback1 = [UserUtterances suggestionFeedbackForTooExpensive:restaurant1 text:@""];
    TalkerUtterance *feedback2 = [UserUtterances suggestionFeedbackForTooFarAway:restaurant2 text:@""];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];
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
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForLike:[[RestaurantBuilder alloc] build] text:@"I like it"]];

    assertThatInteger(self.conversation.negativeUserFeedback.count, is(equalToInteger(0)));
}

-(void)test_negativeUserFeedback_SholdBeEmpty_WhenNewSearchStarted{
    Restaurant *kingsHead = [[RestaurantBuilder alloc] build];
    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:kingsHead text:@""]];
    [self sendInput:[UserUtterances suggestionFeedbackForLike:kingsHead text:@"Cool"]];
    [self sendInput:[UserUtterances wantsToSearchForAnotherRestaurant:@"Search for another restaurant"]];

    assertThatInteger(self.conversation.negativeUserFeedback.count, is(equalToInteger(0)));
}

-(void)test_dislikedRestaurants_ShouldReturnDislikedRestaurantsOfWholeConversation{
    Restaurant *restaurant1 = [[RestaurantBuilder alloc] build];
    Restaurant *restaurant2 = [[RestaurantBuilder alloc] build];
    Restaurant *restaurant3 = [[RestaurantBuilder alloc] build];
    [self configureRestaurantSearchForLocation:_london configuration:^(PlacesAPIStub *stub) {
        [stub injectFindResults:@[restaurant1, restaurant2,restaurant3]];
    }];

    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:restaurant1 text:@""]];
    [self sendInput:[UserUtterances suggestionFeedbackForLike:restaurant2 text:@"Cool"]];
    [self sendInput:[UserUtterances wantsToSearchForAnotherRestaurant:@"Search for another restaurant"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:restaurant3 text:@""]];

    assertThatInteger(self.conversation.dislikedRestaurants.count, is(equalToInteger(2)));
    assertThat(self.conversation.dislikedRestaurants, contains(restaurant1, restaurant3, nil));
}

- (void)test_suggestedRestaurants_ShouldNotBeEmpty_WhenFHHasSuggestedRestaurants {
    Restaurant *restaurant1 = [[RestaurantBuilder alloc] build];
    Restaurant *restaurant2 = [[RestaurantBuilder alloc] build];

    // 1. Restaurant suggested at beginning

    [self sendInput:[UserUtterances suggestionFeedbackForDislike:restaurant1 text:@"I don't like that restaurant"]]; // 2. Restaurant suggested

    [self sendInput:[UserUtterances suggestionFeedbackForDislike:restaurant2 text:@"I don't like that restaurant"]]; // 3. Restaurant suggested
    NSArray *restaurants = [self.conversation suggestedRestaurantsInCurrentSearch];
    assertThatInteger(restaurants.count, is(equalToInteger(3)));
}

- (void)test_currentSearchPreferenceCuisine_ShouldInitializeWithDefaults_WhenUserHasNotSpecifiedCuisineYet {
    SearchProfile *profile = [[self conversation] currentSearchPreference:0 searchLocation:_london];

    assertThat(profile.cuisine, is(equalTo(@"")));
}

- (void)test_currentSearchPreferenceCuisine_ShouldReturnCurrentOccasion_WhenUserHasNotSpecifiedOccasionYet {
    [self.environmentStub injectNow:[NSCalendar dateFromYear:2015 month:3 day:25 hour:13 minute:15 second:14]];

    SearchProfile *profile = [[self conversation] currentSearchPreference:0 searchLocation:_london];

    assertThat(profile.occasion, is(equalTo([Occasions lunch])));
}

- (void)test_currentSearchPreferenceCuisine_ShouldReturnCuisine_WhenUserHasAlreadySpecifiedCuisine {
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Asian, Swiss" location:nil] text:@"Asian, Swiss"]];

    assertThat([self.conversation currentSearchPreference:0 searchLocation:_london].cuisine, is(equalTo(@"Asian, Swiss")));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldBeFullRange_WhenUserHasNotCommentedOnPriceYet {
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Sandwich" location:nil] text:@"I love Sandwich"]];

    PriceRange *fullPriceRange = [PriceRange priceRangeWithoutRestriction];

    assertThat([self.conversation currentSearchPreference:0 searchLocation:_london].priceRange, is(equalTo(fullPriceRange)));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldDecreasePriceLevel_WhenUserFindsRestaurantTooExpensive {
    NSUInteger priceLevel = 3;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:restaurant text:@""]];

    assertThatUnsignedInt([self.conversation currentSearchPreference:0 searchLocation:_london].priceRange.max, is(equalTo(@(priceLevel - 1))));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldNotDecreasePriceLevel_WhenUserFindsRestaurantTooExpensiveButItsAlreadyTheCheapestPossible {
    NSUInteger priceLevel = GOOGLE_PRICE_LEVEL_MIN;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:restaurant text:@"It's far too expensive"]];

    assertThatUnsignedInt([self.conversation currentSearchPreference:0 searchLocation:_london].priceRange.max, is(equalTo(@(GOOGLE_PRICE_LEVEL_MIN))));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldIncreasePriceLevel_WhenUserFindsRestaurantTooCheap {
    NSUInteger priceLevel = 3;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:restaurant text:@"It looks too cheap"]];

    assertThatUnsignedInt([self.conversation currentSearchPreference:0 searchLocation:_norwich].priceRange.min, is(equalTo(@(priceLevel + 1))));
}

- (void)test_currentSearchPreferencePriceLevel_ShouldNotIncreasePriceLevel_WhenUserFindsRestaurantTooCheapButItsAlreadyTheMostExpensivePossible {
    NSUInteger priceLevel = GOOGLE_PRICE_LEVEL_MAX;
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:restaurant text:@"It looks too cheap"]];

    assertThatUnsignedInt([self.conversation currentSearchPreference:0 searchLocation:_norwich].priceRange.min, is(equalTo(@(GOOGLE_PRICE_LEVEL_MAX))));
}

- (void)test_currentSearchPreferenceMaxDistance_ShouldDecrease_WhenUserFindRestaurantTooFarAway {
    CLLocationDistance distance = [_norwich distanceFromLocation:_london];

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withLocation:_norwich] build];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooFarAway:restaurant text:@"It's too far away"]];

    assertThatDouble([self.conversation currentSearchPreference:distance searchLocation:_london].distanceRange.max, is(lessThan(@(distance))));
}

- (void)test_currentSearchPreferenceDistanceRangeShouldBeNil_WhenUserHasNotYetGivenFeedbackRelatedToDistance {
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];

    DistanceRange *distanceRange = [self.conversation currentSearchPreference:15688 searchLocation:_london].distanceRange;
    assertThat(distanceRange, is(nilValue()));
}

- (void)test_currentSearchPreferenceDistanceRangeShouldBeMinimal_WhenUserWantsClosestRestaurant {
    CLLocationDistance distance = [_norwich distanceFromLocation:_london];

    Restaurant *restaurant = [[[RestaurantBuilder alloc] withLocation:_norwich] build];

    [self sendInput:[UserUtterances suggestionFeedbackForTheClosestNow:restaurant text:@"Show me the closest"]];
    DistanceRange *range = [self.conversation currentSearchPreference:distance searchLocation:_london].distanceRange;
    assertThat(range, is(notNilValue()));
    assertThatDouble(range.max, is(equalTo(@0)));
}

- (void)test_currentSearchPreferenceCuisineShouldBeNil_WhenSearchHasBeenRestarted {
    [self configureRestaurantSearchForLatitude:48.00 longitude:-22.23 configuration:^(PlacesAPIStub *stub) {
        [stub injectFindNothing];
    }];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];
    [self sendInput:[UserUtterances tryAgainNow:@"Try again"]];

    NSString *cuisine = [self.conversation currentSearchPreference:15688 searchLocation:_london].cuisine;

    assertThat(cuisine, is(equalTo(@"")));
}

- (void)test_currentSearchPreference_ShouldResetCuisinePreference_WhenNewOccasionPreferred {
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Thai" location:nil] text:@"I like Thai"]];
    [self sendInput:[UserUtterances occasionPreference:[[TextAndLocation alloc] initWithText:@"drink" location:nil] text:@"I want drinks"]];

    NSString *cuisine = [self.conversation currentSearchPreference:15688 searchLocation:_london].cuisine;

    assertThat(cuisine, is(equalTo(@"")));
}

- (void)test_currentSearchPreference_ShouldResetOccasionPreference_WhenNewCuisinePreferred {
    [self sendInput:[UserUtterances occasionPreference:[[TextAndLocation alloc] initWithText:@"drink" location:nil] text:@"I want drinks"]];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"eggs" location:nil] text:@"I like eggs"]];

    NSString *occasion = [self.conversation currentSearchPreference:15688 searchLocation:_london].occasion;

    assertThat(occasion, is(equalTo(@"")));
}

- (void)test_currentSearchPreference_ShouldGuessOccasionPreference_WhenNewCuisinePreferred {
    [self sendInput:[UserUtterances occasionPreference:[[TextAndLocation alloc] initWithText:@"drink" location:nil] text:@"I want drinks"]];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Cake" location:nil] text:@"I wanna cake"]];

    NSString *occasion = [self.conversation currentSearchPreference:15688 searchLocation:_london].occasion;

    assertThat(occasion, is(equalTo([Occasions snack])));
}

- (void)test_currentSearchPreference_ShouldResetCuisinePreference_WhenNewOccasionPreferredAfterAbort {
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Thai" location:nil] text:@"I like Thai"]];
    [self sendInput:[UserUtterances occasionPreference:[[TextAndLocation alloc] initWithText:@"drink" location:nil] text:@"I want drinks"]];
    [self sendInput:[UserUtterances wantsToAbort:@"Forget about it"]];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"Indian" location:nil] text:@"I want Indian food"]];

    NSString *cuisine = [self.conversation currentSearchPreference:15688 searchLocation:_london].cuisine;

    assertThat(cuisine, is(equalTo(@"Indian")));
}

- (void)test_lastSuggestionWarning_ShouldReturnNil_WhenNoSuggestionWarningExists {
    assertThat([self.conversation lastSuggestionWarning], is(nilValue()));
}

- (void)test_lastSuggestionWarning_ShouldReturnLastSuggestionWarning {
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withPriceLevel:3] build];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:restaurant text:@"It looks too cheap"]];

    ConversationParameters *lastSuggestionWarning = [self.conversation lastSuggestionWarning];
    assertThat(lastSuggestionWarning, is(notNilValue()));
    assertThatBool([lastSuggestionWarning hasSemanticId:@"FH:SuggestionIfNotInPreferredRangeTooCheap"], isTrue());
}

- (void)test_statementIndexes_ShouldYieldGreetingAndOpeningQuestion {
    __block NSInteger nrIndexes = 0;
    RACSignal *signal = [self.conversation statementIndexes];
    [signal subscribeNext:^(id next) {
        nrIndexes++;
    }];

    assertThatInteger(nrIndexes, is(equalTo(@(2))));
}

- (void)test_lastUserResponse_ShouldReturnLastUserUtterance {
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withLocation:_norwich] build];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];
    [self sendInput:[UserUtterances suggestionFeedbackForLike:restaurant text:@"Looks cool"]];

    ConversationParameters *lastResponse = [self.conversation lastUserResponse];
    assertThat(lastResponse, isNot(nilValue()));
    assertThatBool([lastResponse hasSemanticId:@"U:SuggestionFeedback=Like"], isTrue());
}

- (void)test_lastUserResponse_ShouldIgnoreUtterancesFromPreviousSearch {
    Restaurant *restaurant = [[[RestaurantBuilder alloc] withLocation:_norwich] build];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I like British Food"]];
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

- (void)test_currentOccasion_ShouldReturnDefaultOccasion_WhenUserHasNotCommentedOccasion {
    [self.environmentStub injectNow:[NSCalendar dateFromYear:2015 month:3 day:25 hour:23 minute:15 second:14]];

    NSString *occasion = [self.conversation currentOccasion];
    assertThat(occasion, is(equalTo([Occasions drink])));
}

- (void)test_currentOccasion_ShouldReturnCorrectOccasion_WhenUserHasCommentedOccasion {
    [self sendInput:[UserUtterances occasionPreference:[[TextAndLocation alloc] initWithText:@"dinner" location:nil] text:@"I want dinner"]];

    NSString *occasion = [self.conversation currentOccasion];
    assertThat(occasion, is(equalTo([Occasions dinner])));
}

- (void)test_id_ShouldAlwaysReturnUserId {
    NSString *id1 = self.conversation.id;
    assertThat(id1, is(equalTo([Configuration userId])));

    [self resetConversationWhenIsWithFeedbackRequest:YES];
    NSString *id2 = self.conversation.id;
    assertThat(id2, is(equalTo([Configuration userId])));
}

- (void)test_lastRawSuggestion_ShouldReturnLastFHSuggestion {
    Statement *suggestion = [self.conversation lastRawSuggestion];

    assertThat(suggestion, is(notNilValue()));
    assertThat(suggestion.text, is(equalTo(@"This is a no brainer.  You should try %@.")));
    assertThat(suggestion.semanticId, is(equalTo(@"FH:Suggestion=King's Head, Norwich")));
    Restaurant *suggestedRestaurant = suggestion.suggestedRestaurant;
    assertThat(suggestedRestaurant.name, is(equalTo(@"King's Head")));

    [self sendInput:[UserUtterances suggestionFeedbackForDislike:suggestedRestaurant text:@"I don't like that restaurant"]];
    suggestion = [self.conversation lastRawSuggestion];

    assertThat(suggestion, is(notNilValue()));
    assertThat(suggestion.text, is(equalTo(@"This is a no brainer.  You should try %@.")));
    assertThat(suggestion.semanticId, is(equalTo(@"FH:Suggestion=Raj Palace, Norwich")));
    assertThat(suggestion.suggestedRestaurant.name, is(equalTo(@"Raj Palace")));

}

- (void)test_currentSearchLocation_ShouldBeNil_WhenUserHasNotUtteredAnyPreference {
    assertThat([self.conversation currentSearchLocation], is(nilValue()));
}

- (void)test_currentSearchLocation_ShouldReturnLocation_WhenUserHasUtteredOccasionAndLocationPreference {
    TextAndLocation *parameter = [[TextAndLocation alloc] initWithText:@"Lunch" location:@"Norwich"];

    [self sendInput:[UserUtterances occasionPreference:parameter text:@"I want Lunch in Norwich"]];

    assertThat([self.conversation currentSearchLocation], is(equalTo(@"Norwich")));
}

- (void)test_currentSearchLocation_ShouldReturnLocation_WhenUserHasUtteredCuisineAndLocationPreference {
    TextAndLocation *parameter = [[TextAndLocation alloc] initWithText:@"Indian" location:@"Norwich"];

    [self sendInput:[UserUtterances cuisinePreference:parameter text:@"I want indian Food in Norwich"]];

    assertThat([self.conversation currentSearchLocation], is(equalTo(@"Norwich")));
}

- (void)test_USuggestionFeedback_ShouldNotBecomeTooChatty_WhenLongConversation{
    Restaurant* r = [[RestaurantBuilder alloc]  build];
    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants chattyThreshold] value:YES];

    // FH starts with a question
    [self assertLastStatementIs:@"FH:Suggestion" state:@"askForSuggestionFeedback"];
    [self assertLastStatementIs:@"FH:FirstQuestion" state:@"askForSuggestionFeedback"];

    [self sendInput:[UserUtterances suggestionFeedbackForDislike:r text:@"I don't like it"]];
    // FH continues with a follow up question
    [self assertLastStatementIs:@"FH:Suggestion" state:@"askForSuggestionFeedback"];
    [self assertLastStatementIs:@"FH:FollowUpQuestion" state:@"askForSuggestionFeedback"];

    [self sendInput:[UserUtterances suggestionFeedbackForDislike:r text:@"I don't like it"]];
    // FH continues a very simple suggestion
    [self assertLastStatementIs:@"FH:SuggestionSimple" state:@"askForSuggestionFeedback"];

    [self sendInput:[UserUtterances suggestionFeedbackForDislike:r text:@"I don't like it"]];
    // FH continues a very simple suggestion
    [self assertLastStatementIs:@"FH:SuggestionSimple" state:@"askForSuggestionFeedback"];

    [self sendInput:[UserUtterances suggestionFeedbackForDislike:r text:@"I don't like it"]];
    // FH continues a complexer suggestion again
    [self assertLastStatementIs:@"FH:Suggestion" state:@"askForSuggestionFeedback"];
    [self assertLastStatementIs:@"FH:FollowUpQuestion" state:@"askForSuggestionFeedback"];
}

@end