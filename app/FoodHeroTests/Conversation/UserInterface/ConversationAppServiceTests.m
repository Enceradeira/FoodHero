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
#import "RestaurantSearchServiceStub.h"
#import "RestaurantBuilder.h"
#import "CLLocationManagerProxyStub.h"
#import "SpeechRecognitionServiceStub.h"
#import "SpeechInterpretation.h"
#import "FoodHero-Swift.h"

@interface ConversationAppServiceTests : XCTestCase

@end

const CGFloat portraitWidth = 200;
const CGFloat landscapeWidth = 400;

@implementation
ConversationAppServiceTests {
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

- (ConversationBubble *)getBubble:(NSUInteger)index {
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
    [self injectInterpretation:text intent:[NSString stringWithFormat:@"SuggestionFeedback_%@", type] entities:nil];

    [FHStates askForFoodPreference];
    [_service addUserText:text];

    NSArray *statementsReversed = [[self statements] linq_reverse];
    ConversationBubble *userFeedback = statementsReversed[1];
    ConversationBubble *newFhSuggestion = statementsReversed[0];
    assertThat(userFeedback.semanticId, is(equalTo([NSString stringWithFormat:@"U:SuggestionFeedback=%@", type])));
    assertThat(userFeedback.textSource, is(equalTo(text)));
    assertThat(newFhSuggestion.semanticId, containsString(fhAnswer));
}

- (void)injectInterpretation:(NSString *)text intent:(NSString *)intent entities:(NSArray *)entities {
    SpeechInterpretation *interpretation = [SpeechInterpretation new];
    interpretation.intent = intent;
    interpretation.text = text;
    interpretation.entities = entities;
    [_speechRecognitionService injectInterpretation:interpretation];
}

- (void)addRecognizedUserTextForCuisinePreference:(NSString *)text entities:(NSArray *)entities {
    [self injectInterpretation:text intent:@"CuisinePreference" entities:entities];
    [FHStates askForFoodPreference];
    [_service addUserText:text];
}

- (void)addRecognizedUserTextForSuggestionFeedback:(NSString *)text intent:(NSString *)intent {
    [self injectInterpretation:text intent:intent entities:nil];
    [FHStates askForSuggestionFeedback];
    [_service addUserText:text];
}


- (void)addRecognizedUserTextForAnswerToWhatToDoNext:(NSString *)text intent:(NSString *)intent {
    [self injectInterpretation:text intent:intent entities:nil];
    [FHStates askForWhatToDoNext];
    [_service addUserText:text];
}

- (ConversationBubble *)getBubbleWithSemanticId:(NSString *)semanticId {
    ConversationBubble *bubble = [[[self statements] linq_where:^(ConversationBubble *b) {
        return (BOOL) ([b.semanticId isEqualToString:semanticId]);
    }] linq_firstOrNil];
    return bubble;
}

- (void)test_getFirstStatement_ShouldAlwaysReturnSameInstanceOfBubble {
    ConversationBubble *bubble1 = [self getBubble:0];
    ConversationBubble *bubble2 = [self getBubble:0];

    assertThat(bubble1, is(sameInstance(bubble2)));
}

- (void)test_getFirstStatement_ShouldReturnDifferentInstanceOfBubble_WhenWidthChanges {
    ConversationBubble *bubble1 = [_service getStatement:0 bubbleWidth:portraitWidth];
    ConversationBubble *bubble2 = [_service getStatement:0 bubbleWidth:landscapeWidth];

    assertThat(bubble1, isNot(sameInstance(bubble2)));
}

- (void)test_getThirdStatement_ShouldReturnUserAnswer_WhenUserHasSaidSomething {
    [self addRecognizedUserTextForCuisinePreference:@"I like British food" entities:@[@"British"]];

    ConversationBubble *bubble = [self getBubble:1];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.semanticId, is(equalTo(@"U:CuisinePreference=British")));
    assertThat(bubble.class, is(equalTo(ConversationBubbleUser.class)));
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenItLooksTooExpensive {
    Restaurant *expensiveRestaurant = [self restaurantWithName:@"Maharaja" withPriceLeel:4 withRelevance:1];
    Restaurant *cheapRestaurant = [self restaurantWithName:@"Raj Palace" withPriceLeel:0 withRelevance:0.8];
    [_searchServiceStub injectFindResults:@[expensiveRestaurant, cheapRestaurant]];
    [self addRecognizedUserTextForCuisinePreference:@"I like Indian food" entities:@[@"Indian"]];; // lets FH suggest "Maharaja" which has higher relevance

    [self assertUserFeedbackForLastSuggestedRestaurant:@"too expensive!!" recognizedIntent:@"tooExpensive" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"];
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenItLooksTooCheap {
    Restaurant *cheapRestaurant = [self restaurantWithName:@"Chippy" withPriceLeel:0 withRelevance:1];
    Restaurant *expensiveRestaurant = [self restaurantWithName:@"Raj Palace" withPriceLeel:4 withRelevance:0.9];
    [_searchServiceStub injectFindResults:@[cheapRestaurant, expensiveRestaurant]];
    [self addRecognizedUserTextForCuisinePreference:@"I like Indian food" entities:@[@"Indian"]]; // lets FH suggest "Chippy" which has higher relevance

    [self assertUserFeedbackForLastSuggestedRestaurant:@"I'm not that cheap" recognizedIntent:@"tooCheap" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"]; // lets FH suggest "Raj Palace"
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenIrDontLikeThatRestaurant {
    [self addRecognizedUserTextForCuisinePreference:@"I like Indian food" entities:@[@"Indian"]]; // lets FH suggest a restaurant
    [self assertUserFeedbackForLastSuggestedRestaurant:@"What a crap place" recognizedIntent:@"Dislike" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"];
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenILikeIt {
    [self addRecognizedUserTextForCuisinePreference:@"I like Indian food" entities:@[@"Indian"]]; // lets FH suggest a restaurant
    [self assertUserFeedbackForLastSuggestedRestaurant:@"That's cool" recognizedIntent:@"Like" fhAnswer:@"FH:WhatToDoNextCommentAfterSuccess"];
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
            withCuisineRelevance:0.1] build];

    [_locationManager injectLatitude:45 longitude:0];
    [_searchServiceStub injectFindResults:@[restaurantWithHigherRelevance, closerRestaurant]];

    [self addRecognizedUserTextForCuisinePreference:@"I like Indian food" entities:@[@"Indian"]]; // lets FH suggest a restaurant
    [self assertUserFeedbackForLastSuggestedRestaurant:@"too far away" recognizedIntent:@"tooFarAway" fhAnswer:@"FH:Suggestion=Chippy, Norwich"];
}

- (void)test_addUserSolvedProblemWithAccessLocationService_ShouldAddUDidResolveProblemWithAccessLocationService {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self addRecognizedUserTextForCuisinePreference:@"I love Indian food" entities:@[@"Indian"]];

    [self injectInterpretation:@"I fixed it! Hurray!" intent:@"TryAgainNow" entities:nil];
    [_service addUserText:@"I fixed it! Hurray!"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:TryAgainNow"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"I fixed it! Hurray!")));
}

- (void)test_addAnswerAfterForWhatToAfterGoodBye_ShouldAddUWantsToSearchForAnotherRestaurant {
    [self addRecognizedUserTextForCuisinePreference:@"I love Indian food" entities:@[@"Indian"]];
    [self addRecognizedUserTextForSuggestionFeedback:@"I like it" intent:@"SuggestionFeedback_Like"];
    [self addRecognizedUserTextForAnswerToWhatToDoNext:@"Good bye mi love" intent:@"GoodBye"];

    [self injectInterpretation:@"search again!" intent:@"WantsToSearchForAnotherRestaurant" entities:nil];
    [_service addUserText:@"search again!"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:WantsToSearchForAnotherRestaurant"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"search again!")));
}

- (void)test_addUserAnswerAfterNoRestaurantWasFound_ShouldAddUTryAgain_WhenUserSaysTryAgain {
    [_searchServiceStub injectFindNothing];
    [self addRecognizedUserTextForCuisinePreference:@"I love Indian food" entities:@[@"Indian"]];

    [self injectInterpretation:@"again please!!" intent:@"TryAgainNow" entities:nil];
    [_service addUserText:@"again please!!"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:TryAgainNow"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"again please!!")));
}

- (void)test_addUserAnswerAfterNoRestaurantWasFound_ShouldAddUWantsToAbort_WhenUserWantsToAbort {
    [_searchServiceStub injectFindNothing];
    [self addRecognizedUserTextForCuisinePreference:@"I love Indian food" entities:@[@"Indian"]];

    [self injectInterpretation:@"Forget it" intent:@"WantsToAbort" entities:nil];
    [_service addUserText:@"Forget it"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:WantsToAbort"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"Forget it")));
}

- (void)test_addUserAnswerForWhatToDoNext_ShouldAddUWantsToSearchForAnotherRestaurant_WhenUserWantsToSearchForAnotherRestaurant {
    [self addRecognizedUserTextForCuisinePreference:@"I love Indian food" entities:@[@"Indian"]];
    [self addRecognizedUserTextForSuggestionFeedback:@"I like it" intent:@"SuggestionFeedback_Like"];

    [self injectInterpretation:@"Search again" intent:@"WantsToSearchForAnotherRestaurant" entities:nil];
    [_service addUserText:@"Search again"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:WantsToSearchForAnotherRestaurant"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"Search again")));
}

- (void)test_addUserAnswerForWhatToDoNext_ShouldAddUGoodBye_WhenUserSaysGoodBye {
    [self addRecognizedUserTextForCuisinePreference:@"I love Indian food" entities:@[@"Indian"]];
    [self addRecognizedUserTextForSuggestionFeedback:@"I like it" intent:@"SuggestionFeedback_Like"];

    [self injectInterpretation:@"No thanks!" intent:@"GoodBye" entities:nil];
    [_service addUserText:@"No thanks!"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:GoodBye"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"No thanks!")));
}

- (void)test_addUserVoiceForInputAction_ShouldAddUCuisinePreference_WhenAskUserCuisinePreferenceAction {
    [self addRecognizedUserTextForCuisinePreference:@"I like Indian food" entities:@[@"Indian"]];;

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:CuisinePreference=Indian"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"I like Indian food")));
}

@end