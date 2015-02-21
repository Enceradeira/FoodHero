//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <OCHamcrest.h>
#import "UCuisinePreference.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "RandomizerStub.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "RestaurantBuilder.h"

@interface ConversationConfirmationIfInNewPreferredRangeTests : ConversationTestsBase
@end

@implementation ConversationConfirmationIfInNewPreferredRangeTests {

    Restaurant *_restaurant;
}

- (void)setUp {
    [super setUp];

    _restaurant = [[RestaurantBuilder alloc] build];
    [self.tokenRandomizerStub injectChoice:@"FH:SuggestionAsFollowUp"];
    [self sendInput:[UCuisinePreference createUtterance:@"British Food" text:@"I love British Food"]];
}

- (void)test_USuggestionFeedbackForTooExpensive_ShouldTriggerFHConfirmationIfInNewPreferredRangeCheaper {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    Restaurant *expensiveRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:4] build];
    [self configureRestaurantSearchForLatitude:0 longitude:0 configuration:^(RestaurantSearchServiceStub *service){
        return [service injectFindResults:@[expensiveRestaurant, cheapRestaurant]];
    }];

    [self.conversation addFHToken:[USuggestionFeedbackForTooExpensive create:expensiveRestaurant text:nil]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeCheaper" state:nil];
}

- (void)test_USuggestionFeedbackForTooFarAways_ShouldTriggerFHConfirmationIfInNewPreferredRangeCloser {
    CLLocation *location = [CLLocation new];
    [self.conversation addFHToken:[USuggestionFeedbackForTooFarAway create:_restaurant currentUserLocation:location text:nil]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeCloser" state:nil];
}

- (void)test_USuggestionFeedbackForTooCheap_ShouldTriggerFHConfirmationIfInNewPreferredRangeMoreExpensive {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    Restaurant *expensiveRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:4] build];
    [self configureRestaurantSearchForLatitude:0 longitude:0 configuration:^(RestaurantSearchServiceStub *service){
        return [service injectFindResults:@[cheapRestaurant, expensiveRestaurant]];
    }];

    [self.conversation addFHToken:[USuggestionFeedbackForTooCheap create:cheapRestaurant text:@"It looks too cheap"]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeMoreExpensive" state:nil];
}


@end