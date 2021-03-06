//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTestsBase.h"
#import "RestaurantBuilder.h"
#import "RestaurantSearchServiceStub.h"
#import "FoodHeroTests-Swift.h"

@interface ConversationSuggestionWithConfirmationIfInNewPreferredRangeTests : ConversationTestsBase
@end

@implementation ConversationSuggestionWithConfirmationIfInNewPreferredRangeTests {

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

    [self configureRestaurantSearchForLocation:_london configuration:^(PlacesAPIStub *stub) {
        [stub injectFindResults:@[_restaurant, _restaurantFarAway, _cheapRestaurant, _expensiveRestaurant]];
    }];

    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants proposal] index:2];
    [self sendInput:[UserUtterances cuisinePreference:[[TextAndLocation alloc] initWithText:@"British Food" location:nil ] text:@"I love British Food"]];
}


- (void)test_USuggestionFeedbackForTooExpensive_ShouldTriggerFHSuggestionIfInNewPreferredRangeCheaper {
    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:_expensiveRestaurant text:@"Way to expensive"]];

    [super assertLastStatementIs:@"FH:SuggestionIfInNewPreferredRangeCheaper" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_USuggestionFeedbackForTooFarAways_ShouldTriggerFHSuggestionIfInNewPreferredRangeCloser {
    [self sendInput:[UserUtterances suggestionFeedbackForTooFarAway:_restaurant text:@"too far"]];

    [super assertLastStatementIs:@"FH:SuggestionIfInNewPreferredRangeCloser" state:[FHStates askForSuggestionFeedback]];
}

- (void)test_USuggestionFeedbackForTooCheap_ShouldTriggerFHSuggestionIfInNewPreferredRangeMoreExpensive {
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:_cheapRestaurant text:@"It looks cheap"]];

    [super assertLastStatementIs:@"FH:SuggestionIfInNewPreferredRangeMoreExpensive" state:[FHStates askForSuggestionFeedback]];
}

@end