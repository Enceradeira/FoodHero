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
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"
#import "RestaurantSearchServiceStub.h"
#import "RestaurantBuilder.h"
#import "CLLocationManagerProxyStub.h"
#import "SpeechRecognitionServiceStub.h"
#import "SpeechInterpretation.h"
#import "UGoodBye.h"

@interface ConversationAppServiceTests : XCTestCase

@end

const CGFloat portraitWidth = 200;
const CGFloat landscapeWidth = 400;

@implementation ConversationAppServiceTests {
    ConversationAppService *_service;
    RestaurantSearchServiceStub *_searchServiceStub;
    CLLocationManagerProxyStub *_locationManager;
    SpeechRecognitionServiceStub *_speechRecognitionService;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _searchServiceStub = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _service = [(id <ApplicationAssembly>) [TyphoonComponents factory] conversationAppService];
    _locationManager = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationManagerProxy];
    _speechRecognitionService = [(id <ApplicationAssembly>) [TyphoonComponents factory] speechRecognitionService];
}

- (ConversationBubble *)getStatement:(NSUInteger)index {
    ConversationBubble *bubble = [_service getStatement:index bubbleWidth:portraitWidth];
    return bubble;
}

- (NSArray *)statements {
    NSMutableArray *statements = [NSMutableArray new];
    for (NSUInteger i = 0; i < [_service getStatementCount]; i++) {
        [statements addObject:[_service getStatement:i bubbleWidth:147]];
    }
    return statements;
}

- (void)userSetsLocationAuthorizationStatus:(CLAuthorizationStatus)status {
    [_locationManager injectAuthorizationStatus:status];
}

- (Restaurant *)restaurantWithName:(NSString *)name withPriceLeel:(NSUInteger)priceLevel withRelevance:(double)cuisineRelevance {
    return [[[[[[RestaurantBuilder alloc] withName:name] withVicinity:@"Norwich"] withPriceLevel:priceLevel] withCuisineRelevance:cuisineRelevance] build];
}

- (void)assertUserFeedbackForLastSuggestedRestaurant:(NSString *)text recognizedIntent:(NSString *)type fhAnswer:(NSString *)fhAnswer {
    [self injectInterpretation:text intent:[NSString stringWithFormat:@"setSuggestionFeedback_%@", type] entities:nil];

    [_service addUserSuggestionFeedback:text];

    NSArray *statementsReversed = [[self statements] linq_reverse];
    ConversationBubble *userFeedback = statementsReversed[1];
    ConversationBubble *newFhSuggestion = statementsReversed[0];
    assertThat(userFeedback.semanticId, is(equalTo([NSString stringWithFormat:@"U:SuggestionFeedback=%@", type])));
    assertThat(userFeedback.textSource, is(equalTo(text)));
    assertThat(newFhSuggestion.semanticId, is(equalTo(fhAnswer)));
}

- (void)injectInterpretation:(NSString *)text intent:(NSString *)intent entities:(NSArray *)entities {
    SpeechInterpretation *interpretation = [SpeechInterpretation new];
    interpretation.intent = intent;
    interpretation.text = text;
    interpretation.entities = entities;
    [_speechRecognitionService injectInterpretation:interpretation];
}

- (void)addRecognizedUserCuisinePreference:(NSString *)text intent:(NSString *)intent entities:(NSArray *)entities {
    [self injectInterpretation:text intent:intent entities:entities];
    [_service addUserCuisinePreference:text];
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

- (void)test_getThirdStatement_ShouldReturnUserAnswer_WhenUserHasSaidSomething {
    id userInput = [UCuisinePreference create:@"British" text:@"I like British food"];
    [_service addUserInput:userInput];

    ConversationBubble *bubble = [self getStatement:2];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.semanticId, is(equalTo(@"U:CuisinePreference=British")));
    assertThat(bubble.class, is(equalTo(ConversationBubbleUser.class)));
}


- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldThrowException_WhenNoRestaurantSuggestedYet {
    assertThat(^() {
        return [_service addUserSuggestionFeedback:@"It's too far away"];
    }, throwsExceptionOfType(DesignByContractException.class));
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenItLooksTooExpensive {
    Restaurant *expensiveRestaurant = [self restaurantWithName:@"Maharaja" withPriceLeel:4 withRelevance:1];
    Restaurant *cheapRestaurant = [self restaurantWithName:@"Raj Palace" withPriceLeel:0 withRelevance:0.8];
    [_searchServiceStub injectFindResults:@[expensiveRestaurant, cheapRestaurant]];

    [_service addUserInput:[UCuisinePreference create:@"Indian" text:@"I like Indian food"]]; // lets FH suggest "Maharaja" which has higher relevance

    [self assertUserFeedbackForLastSuggestedRestaurant:@"It looks too posh" recognizedIntent:@"tooExpensive" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"];
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenItLooksTooCheap {
    Restaurant *cheapRestaurant = [self restaurantWithName:@"Chippy" withPriceLeel:0 withRelevance:1];
    Restaurant *expensiveRestaurant = [self restaurantWithName:@"Raj Palace" withPriceLeel:4 withRelevance:0.9];
    [_searchServiceStub injectFindResults:@[cheapRestaurant, expensiveRestaurant]];

    [_service addUserInput:[UCuisinePreference create:@"Indian" text:@"I like Indian food"]]; // lets FH suggest "Chippy" which has higher relevance

    [self assertUserFeedbackForLastSuggestedRestaurant:@"It looks too cheap" recognizedIntent:@"tooCheap" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"]; // lets FH suggest "Raj Palace"
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenIrDontLikeThatRestaurant {
    [_service addUserInput:[UCuisinePreference create:@"Indian" text:@"I like Indian food"]]; // lets FH suggest a restaurant
    [self assertUserFeedbackForLastSuggestedRestaurant:@"I don't like that restaurant" recognizedIntent:@"Dislike" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"];
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenILikeIt {
    [_service addUserInput:[UCuisinePreference create:@"Indian" text:@"I like Indian food"]]; // lets FH suggest a restaurant
    [self assertUserFeedbackForLastSuggestedRestaurant:@"I like it" recognizedIntent:@"Like" fhAnswer:@"FH:WhatToDoNextCommentAfterSuccess"];
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenItsTooFarAway {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:45 longitude:1];
    CLLocation *closerLocation = [[CLLocation alloc] initWithLatitude:45 longitude:0];

    Restaurant *restaurantWithHigherRelevance = [[[[[[RestaurantBuilder alloc]
            withName:@"Raj Palace"]
            withVicinity:@"Norwich"]
            withLocation:location]
            withCuisineRelevance:1] build];
    Restaurant *closerRestaurant = [[[[[[RestaurantBuilder alloc]
            withName:@"Chippy"]
            withVicinity:@"Norwich"]
            withLocation:closerLocation]
            withCuisineRelevance:0.5] build];

    [_locationManager injectLatitude:45 longitude:0];
    [_searchServiceStub injectFindResults:@[restaurantWithHigherRelevance, closerRestaurant]];

    [_service addUserInput:[UCuisinePreference create:@"Indian" text:@"I like Indian food"]]; // lets FH suggest a restaurant
    [self assertUserFeedbackForLastSuggestedRestaurant:@"It's too far away" recognizedIntent:@"tooFarAway" fhAnswer:@"FH:Suggestion=Chippy, Norwich"];
}

-(void)test_addUserSolvedProblemWithAccessLocationService_ShouldAddUDidResolveProblemWithAccessLocationService{
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self addRecognizedUserCuisinePreference:@"I love Indian food" intent:@"setFoodPreference" entities:@[@"Indian"]];
    [_service addUserSolvedProblemWithAccessLocationService:@"I fixed it! Hurray!"];

    BOOL any = [[self statements] linq_any:^(ConversationBubble * b){
        return (BOOL)([b.semanticId isEqualToString:@"U:DidResolveProblemWithAccessLocationService"]);
    }];

    assertThatBool(any, is(equalToBool(YES)));
}

-(void)test_addUserWantsToSearchForAnotherRestaurant_ShouldAddUWantsToSearchForAnotherRestaurant{
    [self addRecognizedUserCuisinePreference:@"I love Indian food" intent:@"setFoodPreference" entities:@[@"Indian"]];
    [self addRecognizedUserCuisinePreference:@"I like it" intent:@"setSuggestionFeedback_Like" entities:nil];
    [_service addUserInput:[UGoodBye new]];

    [_service addUserWantsToSearchForAnotherRestaurant:@"Do it again!"];
    BOOL any = [[self statements] linq_any:^(ConversationBubble * b){
        return (BOOL)([b.semanticId isEqualToString:@"U:WantsToSearchForAnotherRestaurant"]);
    }];

    assertThatBool(any, is(equalToBool(YES)));
}


@end