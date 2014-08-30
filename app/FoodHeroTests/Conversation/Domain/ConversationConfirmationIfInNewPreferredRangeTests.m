//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <OCHamcrest.h>
#import "UCuisinePreference.h"
#import "ConversationTestsBase.h"
#import "USuggestionNegativeFeedback.h"
#import "AlternationRandomizerStub.h"
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
    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
}

- (void)test_USuggestionFeedbackForTooExpensive_ShouldTriggerFHConfirmationIfInNewPreferredRangeCheaper {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    Restaurant *expensiveRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:4] build];
    [self configureRestaurantSearchForLatitude:0 longitude:0 configuration:^(RestaurantSearchServiceStub *service){
        return [service injectFindResults:@[expensiveRestaurant, cheapRestaurant]];
    }];

    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:expensiveRestaurant]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeCheaper" userAction:nil];
}

- (void)test_USuggestionFeedbackForTooFarAways_ShouldTriggerFHConfirmationIfInNewPreferredRangeCloser {
    CLLocation *location = [CLLocation new];
    [self.conversation addToken:[USuggestionFeedbackForTooFarAway create:_restaurant currentUserLocation:location]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeCloser" userAction:nil];
}

- (void)test_USuggestionFeedbackForTooCheap_ShouldTriggerFHConfirmationIfInNewPreferredRangeMoreExpensive {
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    Restaurant *expensiveRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:4] build];
    [self configureRestaurantSearchForLatitude:0 longitude:0 configuration:^(RestaurantSearchServiceStub *service){
        return [service injectFindResults:@[cheapRestaurant, expensiveRestaurant]];
    }];

    [self.conversation addToken:[USuggestionFeedbackForTooCheap create:cheapRestaurant]];

    [super assertLastStatementIs:@"FH:ConfirmationIfInNewPreferredRangeMoreExpensive" userAction:nil];
}


@end