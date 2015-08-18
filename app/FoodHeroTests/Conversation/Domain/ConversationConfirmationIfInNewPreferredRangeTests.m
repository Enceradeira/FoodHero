//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTestsBase.h"
#import "RestaurantBuilder.h"
#import "FoodHeroTests-Swift.h"
#import <OCHamcrest.h>

@interface ConversationConfirmationIfInNewPreferredRangeTests : ConversationTestsBase
@end

@implementation ConversationConfirmationIfInNewPreferredRangeTests {

    Restaurant *_restaurant;
    CLLocation *_london;
    Restaurant *_restaurantFarAway;
    Restaurant *_cheapRestaurant;
    Restaurant *_expensiveRestaurant;
}

- (void)setUp {
    [super setUp];

    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];
    _restaurant = [[[RestaurantBuilder alloc] withLocation:_london] build];
    _restaurantFarAway = [[[RestaurantBuilder alloc] withLocation:_london] build];
    _cheapRestaurant = [[[[RestaurantBuilder alloc] withPriceLevel:0] withLocation:_london] build];
    _expensiveRestaurant = [[[[RestaurantBuilder alloc] withPriceLevel:4] withLocation:_london] build];
}

- (void)setupAndInjectResults:(NSArray *)results {
    [self resetConversation];

    [self configureRestaurantSearchForLocation:_london configuration:^(PlacesAPIStub *stub) {
        [stub injectFindResults:results];
    }];

    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants proposal] index:1];

    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil] text:@"I love British Food"]];
}

- (void)test_USuggestionFeedbackForTooExpensive_ShouldTriggerFHConfirmationIfInNewPreferredRangeCheaper {
    [self setupAndInjectResults:@[_restaurant, _restaurantFarAway, _cheapRestaurant, _expensiveRestaurant]];

    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:_expensiveRestaurant text:@"too posh"]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeCheaper" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_USuggestionFeedbackForTooFarAways_ShouldTriggerFHConfirmationIfInNewPreferredRangeCloser {
    [self setupAndInjectResults:@[_restaurant, _restaurantFarAway, _cheapRestaurant, _expensiveRestaurant]];

    [self sendInput:[UserUtterances suggestionFeedbackForTooFarAway:_restaurant text:@"too far"]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeCloser" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_USuggestionFeedbackForTooCheap_ShouldTriggerFHConfirmationIfInNewPreferredRangeMoreExpensive {
    [self setupAndInjectResults:@[_restaurant, _restaurantFarAway, _cheapRestaurant, _expensiveRestaurant]];

    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:_cheapRestaurant text:@"It looks too cheap"]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeMoreExpensive" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_USuggestionFeedbackForTooCheap_ShouldNotTriggerFHConfirmationIfInNewPreferredRangeMoreExpensive_WhenRestaurantNotMoreExpensive {
    NSUInteger priceLevel = 1;
    Restaurant *cheap1 = [[[[RestaurantBuilder alloc] withPriceLevel:priceLevel] withName:@"Cheap1"] build];
    Restaurant *cheap2 = [[[[RestaurantBuilder alloc] withPriceLevel:priceLevel] withName:@"Cheap2"] build];
    Restaurant *cheap3 = [[[[RestaurantBuilder alloc] withPriceLevel:priceLevel] withName:@"Cheap2"] build];
    [self setupAndInjectResults:@[cheap1, cheap2, cheap3]];

    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheap1 text:@"It looks too cheap"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheap2 text:@"It looks too cheap"]];

    assertThat([self getLastStatement].semanticId, isNot(containsString(@"FH:ConfirmationIfInNewPreferredRangeMoreExpensive")));
}

- (void)test_USuggestionFeedbackForTooExpensive_ShouldNotTriggerFHConfirmationIfInNewPreferredRangeCheaper_WhenRestaurantNotCheaper {
    NSUInteger priceLevel = 3;
    Restaurant *expensive1 = [[[[RestaurantBuilder alloc] withPriceLevel:priceLevel] withName:@"Exp1"] build];
    Restaurant *expensive2 = [[[[RestaurantBuilder alloc] withPriceLevel:priceLevel] withName:@"Exp2"] build];
    Restaurant *expensive3 = [[[[RestaurantBuilder alloc] withPriceLevel:priceLevel] withName:@"Exp3"] build];
    [self setupAndInjectResults:@[expensive1, expensive2, expensive3]];

    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:expensive1 text:@"It looks too expensive"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:expensive2 text:@"It looks too expensive"]];

    assertThat([self getLastStatement].semanticId, isNot(containsString(@"FH:ConfirmationIfInNewPreferredRangeCheaper")));
}

- (void)test_USuggestionFeedbackForTooFarAway_ShouldNotTriggerFHConfirmationIfInNewPreferredRangeCloser_WhenRestaurantNotClose {
    RestaurantDistance *distance = [[RestaurantDistance alloc] initWithSearchLocation:_london searchLocationDescription:@"" distanceFromSearchLocation:1];
    Restaurant *r1 = [[[[RestaurantBuilder alloc] withDistance:distance] withName:@"1"] build];
    Restaurant *r2 = [[[[RestaurantBuilder alloc] withDistance:distance] withName:@"2"] build];
    Restaurant *r3 = [[[[RestaurantBuilder alloc] withDistance:distance] withName:@"3"] build];
    [self setupAndInjectResults:@[r1, r2, r3]];

    [self sendInput:[UserUtterances suggestionFeedbackForTooFarAway:r1 text:@"Too far away"]];
    [self sendInput:[UserUtterances suggestionFeedbackForTooFarAway:r2 text:@"Too far away"]];

    assertThat([self getLastStatement].semanticId, isNot(containsString(@"FH:ConfirmationIfInNewPreferredRangeCloser")));
}



@end