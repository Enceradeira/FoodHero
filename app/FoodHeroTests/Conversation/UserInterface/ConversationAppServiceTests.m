//
//  ConversationAppServiceTests.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Typhoon.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "DefaultAssembly.h"
#import "ConversationBubbleUser.h"
#import "TyphoonComponents.h"
#import "ConversationAppService.h"
#import "StubAssembly.h"
#import "UCuisinePreference.h"
#import "Cuisine.h"
#import "Feedback.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"
#import "RestaurantSearchServiceStub.h"
#import "RestaurantBuilder.h"

@interface ConversationAppServiceTests : XCTestCase

@end

const CGFloat portraitWidth = 200;
const CGFloat landscapeWidth = 400;

@implementation ConversationAppServiceTests {
    ConversationAppService *_service;
    RestaurantSearchServiceStub *_searchServiceStub;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _searchServiceStub = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _service = [(id <ApplicationAssembly>) [TyphoonComponents factory] conversationAppService];
}

- (ConversationBubble *)getStatement:(NSUInteger)index {
    ConversationBubble *bubble = [_service getStatement:index bubbleWidth:portraitWidth];
    return bubble;
}

- (NSArray *)cuisines {
    NSMutableArray *cuisines = [NSMutableArray new];
    for (NSUInteger i = 0; i < [_service getCuisineCount]; i++) {
        [cuisines addObject:[_service getCuisine:i]];
    }
    return cuisines;
}

- (NSArray *)feedbacks {
    NSMutableArray *feedbacks = [NSMutableArray new];
    for (NSUInteger i = 0; i < [_service getFeedbackCount]; i++) {
        [feedbacks addObject:[_service getFeedback:i]];
    }
    return feedbacks;
}

- (NSArray *)statements {
    NSMutableArray *statements = [NSMutableArray new];
    for (NSUInteger i = 0; i < [_service getStatementCount]; i++) {
        [statements addObject:[_service getStatement:i bubbleWidth:147]];
    }
    return statements;
}

- (Cuisine *)cuisine:(NSString *)name {
    Cuisine *african = [[[self cuisines] linq_where:^(Cuisine *c) {
        return [c.name isEqualToString:name];
    }] linq_firstOrNil];
    return african;
}

- (void)assertUserFeedbackForLastSuggestedRestaurant:(NSString *)feedback fhAnswer:(NSString *)fhAnswer {
    Feedback *anyFeedback = [[[self feedbacks]
            linq_where:^(Feedback *f) {

                return [f.choiceText isEqualToString:feedback];
            }] linq_firstOrNil];

    [_service addUserFeedbackForLastSuggestedRestaurant:anyFeedback];

    NSArray *statementsReversed = [[self statements] linq_reverse];
    ConversationBubble *userFeedback = statementsReversed[1];
    ConversationBubble *newFhSuggestion = statementsReversed[0];
    assertThat(userFeedback.semanticId, is(equalTo([NSString stringWithFormat:@"U:SuggestionFeedback=%@", feedback])));
    assertThat(newFhSuggestion.semanticId, is(equalTo(fhAnswer)));
}


- (void)test_getFirstStatement_ShouldAlwaysReturnSameInstanceOfBubble {
    ConversationBubble *bubble1 = [self getStatement:0];
    ConversationBubble *bubble2 = [self getStatement:0];

    assertThat(bubble1, is(sameInstance(bubble2)));
}

- (void)test_getFirstStatement_ShouldReturnDifferentInstanceOfBubble_WhenWidthChanges {
    ConversationBubble *bubble1 = [_service getStatement:0 bubbleWidth:portraitWidth];
    ConversationBubble *bubble2 = [_service getStatement:0 bubbleWidth:landscapeWidth];

    assertThat(bubble1, isNot(sameInstance(bubble2)));
}

- (void)test_getSecondStatement_ShouldReturnUserAnswer_WhenUserHasSaidSomething {
    id userInput = [UCuisinePreference create:@"British or Indian Food"];
    [_service addUserInput:userInput];

    ConversationBubble *bubble = [self getStatement:1];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.semanticId, is(equalTo(@"U:CuisinePreference=British or Indian Food")));
    assertThat(bubble.class, is(equalTo(ConversationBubbleUser.class)));
}

- (void)test_getCuisineCount_ShouldReturnCountGreaterThan0 {
    assertThatInteger([_service getCuisineCount], is(greaterThan(@0)));
}

- (void)test_getCuisine_ShouldReturnCuisineForIndex {
    Cuisine *cuisine0 = [_service getCuisine:0];
    Cuisine *cuisine1 = [_service getCuisine:1];

    assertThat(cuisine0, is(notNilValue()));
    assertThat(cuisine1, is(notNilValue()));
}

- (void)test_getCuisine_ShouldAlwaysReturnSameInstance {
    Cuisine *cuisine = [_service getCuisine:0];
    cuisine.isSelected = !cuisine.isSelected;

    Cuisine *cuisineSameInstance = [_service getCuisine:0];
    assertThatBool(cuisine.isSelected, is(equalToBool(cuisineSameInstance.isSelected)));
}

- (void)test_getSelectedCuisineText_ShouldBeEmpty_WhenNoCuisineSelected {
    assertThat([_service getSelectedCuisineText], is(equalTo(@"")));
}

- (void)test_getSelectedCuisineText_ShouldContainCuisine_WhenOneCuisineSelected {
    [self cuisine:@"African"].isSelected = YES;
    assertThat([_service getSelectedCuisineText], is(equalTo(@"African")));
}

- (void)test_getSelectedCuisineText_ShouldContainTwoCuisines_WhenTwoCuisinesSelected {
    [self cuisine:@"Greek"].isSelected = YES;
    [self cuisine:@"African"].isSelected = YES;
    assertThat([_service getSelectedCuisineText], is(equalTo(@"Greek or African")));
}

- (void)test_getSelectedCuisineText_ShouldContainThreeCuisines_WhenThreeCuisinesSelected {
    [self cuisine:@"Greek"].isSelected = YES;
    [self cuisine:@"African"].isSelected = YES;
    [self cuisine:@"German"].isSelected = YES;
    assertThat([_service getSelectedCuisineText], is(equalTo(@"Greek, African or German")));
}

- (void)test_getFeedbackCount_ShouldReturnCountGreaterThan0 {
    assertThatInteger([_service getFeedbackCount], is(greaterThan(@0)));
}

- (void)test_getFeedback_ShouldReturnCuisineForIndex {
    Feedback *feedback0 = [_service getFeedback:0];
    Feedback *feedback1 = [_service getFeedback:1];

    assertThat(feedback0, is(notNilValue()));
    assertThat(feedback1, is(notNilValue()));
}

- (void)test_getFeedback_ShouldReturnFeedbackWithImage {
    for (Feedback *f in [self feedbacks]) {
        assertThat(f.image, is(notNilValue()));
    }
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldThrowException_WhenNoRestaurantSuggestedYet {
    Feedback *feedback = [_service getFeedback:0];
    assertThat(^() {
        return [_service addUserFeedbackForLastSuggestedRestaurant:feedback];
    }, throwsExceptionOfType(DesignByContractException.class));
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenItsTooFarAway {
    [_service addUserInput:[UCuisinePreference create:@"Indian"]]; // lets FH suggest a restaurant
    [self assertUserFeedbackForLastSuggestedRestaurant:@"It's too far away" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"];
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenItLooksTooExpensive {
    Restaurant *expensiveRestaurant = [[[[[RestaurantBuilder alloc] withName:@"Chippy"] withVicinity:@""] withPriceLevel:4] build];
    Restaurant *cheapRestaurant = [[[[[RestaurantBuilder alloc] withName:@"Raj Palace"] withVicinity:@"Norwich"] withPriceLevel:0] build];
    [_searchServiceStub injectFindResults:@[expensiveRestaurant, cheapRestaurant]];

    [_service addUserInput:[UCuisinePreference create:@"Indian"]]; // lets FH suggest a restaurant
    [self assertUserFeedbackForLastSuggestedRestaurant:@"It looks too expensive" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"];
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenItLooksTooCheap {
    Restaurant *cheapRestaurant = [[[[[RestaurantBuilder alloc] withName:@"Chippy"] withVicinity:@""] withPriceLevel:0] build];
    Restaurant *expensiveRestaurant = [[[[[RestaurantBuilder alloc] withName:@"Raj Palace"] withVicinity:@"Norwich"] withPriceLevel:4] build];
    [_searchServiceStub injectFindResults:@[cheapRestaurant, expensiveRestaurant]];

    [_service addUserInput:[UCuisinePreference create:@"Indian"]]; // lets FH suggest "Chippy"

    [self assertUserFeedbackForLastSuggestedRestaurant:@"It looks too cheap" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"]; // lets FH suggest "Raj Palace"
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenIDontLikeThatRestaurant {
    [_service addUserInput:[UCuisinePreference create:@"Indian"]]; // lets FH suggest a restaurant
    [self assertUserFeedbackForLastSuggestedRestaurant:@"I don't like that restaurant" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"];
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenILikeIt {
    [_service addUserInput:[UCuisinePreference create:@"Indian"]]; // lets FH suggest a restaurant
    [self assertUserFeedbackForLastSuggestedRestaurant:@"I like it" fhAnswer:@"FH:WhatToDoNext"];
}

@end