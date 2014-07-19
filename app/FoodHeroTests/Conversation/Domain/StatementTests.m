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
#import "USuggestionFeedback.h"

@interface StatementTests : XCTestCase

@end

@implementation StatementTests {
    Restaurant *_restaurant;
}

- (void)setUp {
    [super setUp];
    _restaurant =      [Restaurant createWithName:@"Roessli" vicinity:@"Adligenswil" types:nil placeId:nil];
}


-(void)test_suggestedRestaurant_ShouldReturnNil_WhenTokenIsNotFHSuggestion{
    Statement *statement = [Statement create:[FHOpeningQuestion new] inputAction:nil];
    assertThat(statement.suggestedRestaurant, is(nilValue()));
}

-(void)test_suggestedRestaurant_ShouldReturnRestaurantFromToken_WhenTokenIsFHSuggestion{
    Statement *statement = [Statement create:[FHSuggestion create:_restaurant] inputAction:nil];
    assertThat(statement.suggestedRestaurant, is(equalTo(_restaurant)));
}

-(void)test_suggestedRestaurant_ShouldReturnRestaurantFromToken_WhenTokenIsFHSuggestionFeedback{
    Statement *statement = [Statement create:[USuggestionFeedback createForRestaurant:_restaurant parameter:@"not nice"] inputAction:nil];
    assertThat(statement.suggestedRestaurant, is(equalTo(_restaurant)));
}

@end
