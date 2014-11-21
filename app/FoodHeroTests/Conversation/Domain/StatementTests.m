//
//  StatementTests.m
//  FoodHero
//
//  Created by Jorg on 19/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "Statement.h"
#import "FHOpeningQuestion.h"
#import "FHSuggestion.h"
#import "USuggestionNegativeFeedback.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "RestaurantBuilder.h"
#import "FHSuggestionAfterWarning.h"

@interface StatementTests : XCTestCase

@end

@implementation StatementTests {
    Restaurant *_restaurant;
}

- (void)setUp {
    [super setUp];
    _restaurant = [[RestaurantBuilder alloc] build];
}


- (void)test_suggestedRestaurant_ShouldReturnNil_WhenTokenIsNotFHSuggestion {
    Statement *statement = [Statement create:[FHOpeningQuestion new] inputAction:nil];
    assertThat(statement.suggestedRestaurant, is(nilValue()));
}

- (void)test_suggestedRestaurant_ShouldReturnRestaurantFromToken_WhenTokenIsFHSuggestion {
    Statement *statement = [Statement create:[FHSuggestion create:_restaurant] inputAction:nil];
    assertThat(statement.suggestedRestaurant, is(equalTo(_restaurant)));
}

- (void)test_suggestedRestaurant_ShouldReturnRestaurantFromToken_WhenTokenIsFHSuggestionAfterWarning {
    Statement *statement = [Statement create:[FHSuggestionAfterWarning create:_restaurant] inputAction:nil];
    assertThat(statement.suggestedRestaurant, is(equalTo(_restaurant)));
}

- (void)test_suggestedRestaurant_ShouldReturnRestaurantFromToken_WhenTokenIsFHSuggestionFeedback {
    Statement *statement = [Statement create:[USuggestionFeedbackForNotLikingAtAll create:_restaurant text:@"I don't like that restaurant"] inputAction:nil];
    assertThat(statement.suggestedRestaurant, is(equalTo(_restaurant)));
}

@end
