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
}

- (void)setUp {
    [super setUp];

    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];
    _restaurant = [[RestaurantBuilder alloc] build];
    [self.talkerRandomizerFake willChooseForTag:[RandomizerConstants proposal] index:1];

    [self sendInput:[UserUtterances cuisinePreference:@"British Food" text:@"I love British Food"]];
}

- (void)test_USuggestionFeedbackForTooExpensive_ShouldTriggerFHConfirmationIfInNewPreferredRangeCheaper {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    Restaurant *expensiveRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:4] build];
    [self configureRestaurantSearchForLatitude:0 longitude:0 configuration:^(RestaurantSearchServiceStub *service) {
        return [service injectFindResults:@[expensiveRestaurant, cheapRestaurant]];
    }];

    [self sendInput:[UserUtterances suggestionFeedbackForTooExpensive:expensiveRestaurant currentUserLocation:_london text:@"too posh"]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeCheaper" state:[FHStates  askForSuggestionFeedback]];
}

- (void)test_USuggestionFeedbackForTooFarAways_ShouldTriggerFHConfirmationIfInNewPreferredRangeCloser {
    CLLocation *location = [CLLocation new];
    [self sendInput:[UserUtterances suggestionFeedbackForTooFarAway:_restaurant currentUserLocation:location text:@"too far"]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeCloser" state:[FHStates  askForSuggestionFeedback]];
}

- (void)test_USuggestionFeedbackForTooCheap_ShouldTriggerFHConfirmationIfInNewPreferredRangeMoreExpensive {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    Restaurant *expensiveRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:4] build];
    [self configureRestaurantSearchForLatitude:0 longitude:0 configuration:^(RestaurantSearchServiceStub *service) {
        return [service injectFindResults:@[cheapRestaurant, expensiveRestaurant]];
    }];

    [self sendInput:[UserUtterances suggestionFeedbackForTooCheap:cheapRestaurant currentUserLocation:_london text:@"It looks too cheap"]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeMoreExpensive" state:[FHStates  askForSuggestionFeedback]];
}


@end