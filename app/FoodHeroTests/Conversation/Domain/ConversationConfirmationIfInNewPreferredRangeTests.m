//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTestsBase.h"
#import "RestaurantBuilder.h"

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

    [self configureRestaurantSearchForLocation:_london configuration:^(RestaurantSearchServiceStub *stub) {
        [stub injectFindResults:@[_restaurant, _restaurantFarAway, _cheapRestaurant, _expensiveRestaurant]];
    }];
    
    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants proposal] index:1];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I love British Food"]];
}

- (void)test_USuggestionFeedbackForTooExpensive_ShouldTriggerFHConfirmationIfInNewPreferredRangeCheaper {
    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:_expensiveRestaurant currentUserLocation:_london text:@"too posh"]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeCheaper" state:[FHStates  askForSuggestionFeedback]];
}

- (void)test_USuggestionFeedbackForTooFarAways_ShouldTriggerFHConfirmationIfInNewPreferredRangeCloser {
    [self sendInput:[UserUtterances suggestionFeedbackForTooFarAway:_restaurant currentUserLocation:_london text:@"too far"]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeCloser" state:[FHStates  askForSuggestionFeedback]];
}

- (void)test_USuggestionFeedbackForTooCheap_ShouldTriggerFHConfirmationIfInNewPreferredRangeMoreExpensive {
    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:_cheapRestaurant currentUserLocation:_london text:@"It looks too cheap"]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeMoreExpensive" state:[FHStates  askForSuggestionFeedback]];
}


@end