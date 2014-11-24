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
#import "AskUserCuisinePreferenceAction.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "AskUserToTryAgainAction.h"
#import "AskUserWhatToDoNextAction.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"
#import "AskUserWhatToDoAfterGoodByeAction.h"

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

    [_service addUserText:text forInputAction:[AskUserSuggestionFeedbackAction new]];

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

- (void)addRecognizedUserCuisinePreference:(NSString *)text entities:(NSArray *)entities {
    [self injectInterpretation:text intent:@"setFoodPreference" entities:entities];
    [_service addUserText:text forInputAction:[AskUserCuisinePreferenceAction new]];
}

- (void)addRecognizedUserSuggestionFeedback:(NSString *)text intent:(NSString*)intent {
    [self injectInterpretation:text intent:intent entities:nil];
    [_service addUserText:text forInputAction:[AskUserSuggestionFeedbackAction new]];
}

- (void)addRecognizedUserAnswerForWhatToDoNext:(NSString *)text intent:(NSString*)intent {
    [self injectInterpretation:text intent:intent entities:nil];
    [_service addUserText:text forInputAction:[AskUserWhatToDoNextAction new]];
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
    [self addRecognizedUserCuisinePreference:@"I like British food" entities:@[@"British"]];

    ConversationBubble *bubble = [self getStatement:2];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.semanticId, is(equalTo(@"U:CuisinePreference=British")));
    assertThat(bubble.class, is(equalTo(ConversationBubbleUser.class)));
}


- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldThrowException_WhenNoRestaurantSuggestedYet {
    [self injectInterpretation:@"It's too far away" intent: @"setSuggestionFeedback_tooFarAway" entities:nil];
    assertThat(^() {
        return [_service addUserText:@"It's too far away" forInputAction:[AskUserSuggestionFeedbackAction new]];
    }, throwsExceptionOfType(DesignByContractException.class));
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenItLooksTooExpensive {
    Restaurant *expensiveRestaurant = [self restaurantWithName:@"Maharaja" withPriceLeel:4 withRelevance:1];
    Restaurant *cheapRestaurant = [self restaurantWithName:@"Raj Palace" withPriceLeel:0 withRelevance:0.8];
    [_searchServiceStub injectFindResults:@[expensiveRestaurant, cheapRestaurant]];
    [self addRecognizedUserCuisinePreference:@"I like Indian food" entities:@[@"Indian"]];; // lets FH suggest "Maharaja" which has higher relevance

    [self assertUserFeedbackForLastSuggestedRestaurant:@"too expensive!!" recognizedIntent:@"tooExpensive" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"];
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenItLooksTooCheap {
    Restaurant *cheapRestaurant = [self restaurantWithName:@"Chippy" withPriceLeel:0 withRelevance:1];
    Restaurant *expensiveRestaurant = [self restaurantWithName:@"Raj Palace" withPriceLeel:4 withRelevance:0.9];
    [_searchServiceStub injectFindResults:@[cheapRestaurant, expensiveRestaurant]];
    [self addRecognizedUserCuisinePreference:@"I like Indian food" entities:@[@"Indian"]]; // lets FH suggest "Chippy" which has higher relevance

    [self assertUserFeedbackForLastSuggestedRestaurant:@"I'm not that cheap" recognizedIntent:@"tooCheap" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"]; // lets FH suggest "Raj Palace"
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenIrDontLikeThatRestaurant {
    [self addRecognizedUserCuisinePreference:@"I like Indian food" entities:@[@"Indian"]]; // lets FH suggest a restaurant
    [self assertUserFeedbackForLastSuggestedRestaurant:@"What a crap place" recognizedIntent:@"Dislike" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"];
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenILikeIt {
    [self addRecognizedUserCuisinePreference:@"I like Indian food" entities:@[@"Indian"]]; // lets FH suggest a restaurant
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
            withCuisineRelevance:0.5] build];

    [_locationManager injectLatitude:45 longitude:0];
    [_searchServiceStub injectFindResults:@[restaurantWithHigherRelevance, closerRestaurant]];

    [self addRecognizedUserCuisinePreference:@"I like Indian food" entities:@[@"Indian"]]; // lets FH suggest a restaurant
    [self assertUserFeedbackForLastSuggestedRestaurant:@"too far away" recognizedIntent:@"tooFarAway" fhAnswer:@"FH:Suggestion=Chippy, Norwich"];
}

- (void)test_addUserSolvedProblemWithAccessLocationService_ShouldAddUDidResolveProblemWithAccessLocationService {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [self addRecognizedUserCuisinePreference:@"I love Indian food" entities:@[@"Indian"]];
    [_service addUserText:@"I fixed it! Hurray!" forInputAction:[AskUserIfProblemWithAccessLocationServiceResolved new]];

    ConversationBubble *bubble = [[[self statements] linq_where:^(ConversationBubble *b) {
        return (BOOL) ([b.semanticId isEqualToString:@"U:DidResolveProblemWithAccessLocationService"]);
    }] linq_firstOrNil];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"I fixed it! Hurray!")));
}

- (void)test_addAnswerAfterForWhatToAfterGoodBye_ShouldAddUWantsToSearchForAnotherRestaurant {
    [self addRecognizedUserCuisinePreference:@"I love Indian food" entities:@[@"Indian"]];
    [self addRecognizedUserSuggestionFeedback:@"I like it" intent:@"setSuggestionFeedback_Like"];
    [self addRecognizedUserAnswerForWhatToDoNext:@"Good bye mi love" intent:@"goodBye"];

    [_service addUserText:@"search again!" forInputAction:[AskUserWhatToDoAfterGoodByeAction new]];

    ConversationBubble *bubble = [[[self statements] linq_where:^(ConversationBubble *b) {
        return (BOOL) ([b.semanticId isEqualToString:@"U:WantsToSearchForAnotherRestaurant"]);
    }] linq_firstOrNil];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"search again!")));
}

- (void)test_addUserAnswerAfterNoRestaurantWasFound_ShouldAddUTryAgain_WhenUserSaysTryAgain {
    [_searchServiceStub injectFindNothing];
    [self addRecognizedUserCuisinePreference:@"I love Indian food" entities:@[@"Indian"]];

    [self injectInterpretation:@"again please!!" intent:@"tryAgainNow" entities:nil];
    [_service addUserText:@"again please!!" forInputAction:[AskUserToTryAgainAction new]];

    ConversationBubble *bubble = [[[self statements] linq_where:^(ConversationBubble *b) {
        return (BOOL) ([b.semanticId isEqualToString:@"U:TryAgainNow"]);
    }] linq_firstOrNil];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"again please!!")));
}

- (void)test_addUserAnswerAfterNoRestaurantWasFound_ShouldAddUWantsToAbort_WhenUserWantsToAbort {
    [_searchServiceStub injectFindNothing];
    [self addRecognizedUserCuisinePreference:@"I love Indian food" entities:@[@"Indian"]];

    [self injectInterpretation:@"Forget it" intent:@"abort" entities:nil];
    [_service addUserText:@"Forget it" forInputAction:[AskUserToTryAgainAction new]];

    ConversationBubble *bubble = [[[self statements] linq_where:^(ConversationBubble *b) {
        return (BOOL) ([b.semanticId isEqualToString:@"U:WantsToAbort"]);
    }] linq_firstOrNil];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"Forget it")));
}

- (void)test_addUserAnswerForWhatToDoNext_ShouldAddUWantsToSearchForAnotherRestaurant_WhenUserWantsToSearchForAnotherRestaurant {
    [self addRecognizedUserCuisinePreference:@"I love Indian food" entities:@[@"Indian"]];
    [self addRecognizedUserSuggestionFeedback:@"I like it" intent:@"setSuggestionFeedback_Like"];

    [self injectInterpretation:@"Search again" intent:@"searchForAnotherRestaurant" entities:nil];
    [_service addUserText:@"Search again" forInputAction:[AskUserWhatToDoNextAction new]];

    ConversationBubble *bubble = [[[self statements] linq_where:^(ConversationBubble *b) {
        return (BOOL) ([b.semanticId isEqualToString:@"U:WantsToSearchForAnotherRestaurant"]);
    }] linq_firstOrNil];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"Search again")));
}

- (void)test_addUserAnswerForWhatToDoNext_ShouldAddUGoodBye_WhenUserSaysGoodBye {
    [self addRecognizedUserCuisinePreference:@"I love Indian food" entities:@[@"Indian"]];
    [self addRecognizedUserSuggestionFeedback:@"I like it" intent:@"setSuggestionFeedback_Like"];

    [self injectInterpretation:@"No thanks!" intent:@"goodBye" entities:nil];
    [_service addUserText:@"No thanks!" forInputAction:[AskUserWhatToDoNextAction new]];

    ConversationBubble *bubble = [[[self statements] linq_where:^(ConversationBubble *b) {
        return (BOOL) ([b.semanticId isEqualToString:@"U:GoodBye"]);
    }] linq_firstOrNil];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"No thanks!")));
}

@end