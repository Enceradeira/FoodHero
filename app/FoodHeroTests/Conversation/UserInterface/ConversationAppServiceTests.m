//
//  ConversationAppServiceTests.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Typhoon/Typhoon.h>
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
#import "FoodHeroTests-Swift.h"
#import "FoodHero-Swift.h"

@interface ConversationAppServiceTests : XCTestCase

@end

const CGFloat portraitWidth = 200;
const CGFloat landscapeWidth = 400;

@implementation
ConversationAppServiceTests {
    ConversationAppService *_service;
    RestaurantSearchServiceStub *_searchServiceStub;
    PlacesAPIStub *_placesAPIStub;
    CLLocationManagerProxyStub *_locationManager;
    SpeechRecognitionServiceStub *_speechRecognitionService;
    ConversationRepository *_conversationRepository;
    UIApplication *_application;
}

- (void)setUp {
    [super setUp];

    _application = [UIApplication sharedApplication];
    [_application cancelAllLocalNotifications];

    [ConversationRepository deletePersistedData];
    [TyphoonComponents configure:[StubAssembly new]];
    _searchServiceStub = [[TyphoonComponents getAssembly] restaurantSearchService];
    _placesAPIStub = (PlacesAPIStub *)[[TyphoonComponents getAssembly] placesAPI];
    _conversationRepository = [[TyphoonComponents getAssembly] conversationRepository];
    _service = [[TyphoonComponents getAssembly] conversationAppService];
    _locationManager = [[TyphoonComponents getAssembly] locationManagerProxy];
    _speechRecognitionService = [[TyphoonComponents getAssembly] speechRecognitionService];
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
    [_service addUserText:text];
}

- (void)addRecognizedUserTextForSuggestionFeedback:(NSString *)text intent:(NSString *)intent {
    [self injectInterpretation:text intent:intent entities:nil];
    [_service addUserText:text];
}


- (void)addRecognizedUserTextForAnswerToWhatToDoNext:(NSString *)text intent:(NSString *)intent {
    [self injectInterpretation:text intent:intent entities:nil];
    [FHStates askForWhatToDoNext];
    [_service addUserText:text];
}

- (ConversationBubble *)getBubbleWithSemanticId:(NSString *)semanticId {
    ConversationBubble *bubble = [[[self statements] linq_where:^(ConversationBubble *b) {
        return (BOOL) ( [b.semanticId rangeOfString:semanticId].location != NSNotFound);
    }] linq_firstOrNil];
    return bubble;
}

- (void)assertMappingForIntent:(NSString *)intent andEntities:(NSArray *)entities mappedTo:(NSString *)semanticId {
    [_service startWithFeedbackRequest:NO];

    [self injectInterpretation:@"I want to have breakfast" intent:intent entities:entities];
    [_service addUserText:@"I want to have breakfast"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:semanticId];
    assertThat(bubble, is(notNilValue()));
}

- (void)test_getFirstStatement_ShouldAlwaysReturnSameInstanceOfBubble {
    [_service startWithFeedbackRequest:NO];

    ConversationBubble *bubble1 = [self getBubble:0];
    ConversationBubble *bubble2 = [self getBubble:0];

    assertThat(bubble1, is(sameInstance(bubble2)));
}

- (void)test_conversationStart_ShouldSetStateOnSpeechRecognitionService {
    [_service startWithFeedbackRequest:NO];

    assertThat(_speechRecognitionService.state, is(equalTo(@"askForSuggestionFeedback")));
}

- (void)test_conversationStart_ShouldSetThreadIdOnSpeechRecognitionService {
    Conversation *onlyConversation = [_conversationRepository getForInput:[RACSignal new]];

    [_service startWithFeedbackRequest:NO];

    assertThat(_speechRecognitionService.threadId, is(equalTo(onlyConversation.id)));
}

- (void)test_getFirstStatement_ShouldReturnDifferentInstanceOfBubble_WhenWidthChanges {
    [_service startWithFeedbackRequest:NO];

    ConversationBubble *bubble1 = [_service getStatement:0 bubbleWidth:portraitWidth];
    ConversationBubble *bubble2 = [_service getStatement:0 bubbleWidth:landscapeWidth];

    assertThat(bubble1, isNot(sameInstance(bubble2)));
}

- (void)test_addOccasionPreference_ShouldTriggerFHDidNotUnderstandAndAsksForRepetition_WhenNoEntitiesReturned {
    [_service startWithFeedbackRequest:NO];

    [self injectInterpretation:@"I want to have" intent:@"OccasionPreference" entities:nil];
    [_service addUserText:@"I want to have"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"FH:DidNotUnderstandAndAsksForRepetition"];
    assertThat(bubble, is(notNilValue()));
}

- (void)test_addCuisinePreference_ShouldTriggerFHDidNotUnderstandAndAsksForRepetition_WhenNoEntitiesReturned {
    [_service startWithFeedbackRequest:NO];

    [self injectInterpretation:@"I want to have" intent:@"CuisinePreference" entities:nil];
    [_service addUserText:@"I want to have"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"FH:DidNotUnderstandAndAsksForRepetition"];
    assertThat(bubble, is(notNilValue()));
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenItLooksTooExpensive {
    Restaurant *expensiveRestaurant = [self restaurantWithName:@"Maharaja" withPriceLeel:4 withRelevance:1];
    Restaurant *cheapRestaurant = [self restaurantWithName:@"Raj Palace" withPriceLeel:0 withRelevance:0.8];
    [_placesAPIStub injectFindResults:@[expensiveRestaurant, cheapRestaurant]];

    [_service startWithFeedbackRequest:NO];

    [self assertUserFeedbackForLastSuggestedRestaurant:@"too expensive!!" recognizedIntent:@"tooExpensive" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"];
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenItLooksTooCheap {
    Restaurant *cheapRestaurant = [self restaurantWithName:@"Chippy" withPriceLeel:0 withRelevance:1];
    Restaurant *expensiveRestaurant = [self restaurantWithName:@"Raj Palace" withPriceLeel:4 withRelevance:0.9];
    [_placesAPIStub injectFindResults:@[cheapRestaurant, expensiveRestaurant]];

    [_service startWithFeedbackRequest:NO];

    [self assertUserFeedbackForLastSuggestedRestaurant:@"I'm not that cheap" recognizedIntent:@"tooCheap" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"]; // lets FH suggest "Raj Palace"
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenIrDontLikeThatRestaurant {
    [_service startWithFeedbackRequest:NO];
    [self assertUserFeedbackForLastSuggestedRestaurant:@"What a crap place" recognizedIntent:@"Dislike" fhAnswer:@"FH:Suggestion=Raj Palace, Norwich"];
}

- (void)test_addUserFeedbackForLastSuggestedRestaurant_ShouldAddFeedbackForLastSuggestedRestaurant_WhenILikeIt {
    [_service startWithFeedbackRequest:NO];
    [self injectInterpretation:@"That's cool" intent:@"SuggestionFeedback_Like" entities:nil];
    [_service addUserText:@"That's cool"];

    NSArray *statementsReversed = [[self statements] linq_reverse];
    ConversationBubble *userFeedback = statementsReversed[1];
    ConversationBubble *newFhSuggestion = statementsReversed[0];
    assertThat(userFeedback.semanticId, is(equalTo(@"U:SuggestionFeedback=Like")));
    assertThat(userFeedback.textSource, is(equalTo(@"<a href=''>That's cool</a>")));
    assertThat(newFhSuggestion.semanticId, containsString(@"FH:WhatToDoNextCommentAfterSuccess"));
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
    [_placesAPIStub injectFindResults:@[restaurantWithHigherRelevance, closerRestaurant]];
    [_service startWithFeedbackRequest:NO];

    [self assertUserFeedbackForLastSuggestedRestaurant:@"too far away" recognizedIntent:@"tooFarAway" fhAnswer:@"FH:Suggestion=Chippy, Norwich"];
}

- (void)test_addUserSolvedProblemWithAccessLocationService_ShouldAddUDidResolveProblemWithAccessLocationService {
    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
    [_service startWithFeedbackRequest:NO];
    [self addRecognizedUserTextForCuisinePreference:@"I love Indian food" entities:@[[[SpeechEntity alloc] initWithType:@"food_type" value:@"Indian"]]];

    [self injectInterpretation:@"I fixed it! Hurray!" intent:@"TryAgainNow" entities:nil];
    [_service addUserText:@"I fixed it! Hurray!"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:TryAgainNow"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"I fixed it! Hurray!")));
}

- (void)test_addAnswerAfterForWhatToAfterGoodBye_ShouldAddUWantsToSearchForAnotherRestaurant {
    [_service startWithFeedbackRequest:NO];

    [self addRecognizedUserTextForSuggestionFeedback:@"I like it" intent:@"SuggestionFeedback_Like"];
    [self addRecognizedUserTextForAnswerToWhatToDoNext:@"Good bye mi love" intent:@"GoodBye"];

    [self injectInterpretation:@"search again!" intent:@"WantsToSearchForAnotherRestaurant" entities:nil];
    [_service addUserText:@"search again!"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:WantsToSearchForAnotherRestaurant"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"search again!")));
}

- (void)test_addUserAnswerAfterNoRestaurantWasFound_ShouldAddUTryAgain_WhenUserSaysTryAgain {
    [_placesAPIStub injectFindNothing];
    [_service startWithFeedbackRequest:NO];

    [self injectInterpretation:@"again please!!" intent:@"TryAgainNow" entities:nil];
    [_service addUserText:@"again please!!"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:TryAgainNow"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"again please!!")));
}

- (void)test_addUserAnswerAfterNoRestaurantWasFound_ShouldAddUWantsToAbort_WhenUserWantsToAbort {
    [_placesAPIStub injectFindNothing];
    [_service startWithFeedbackRequest:NO];

    [self injectInterpretation:@"Forget it" intent:@"WantsToAbort" entities:nil];
    [_service addUserText:@"Forget it"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:WantsToAbort"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"Forget it")));
}

- (void)test_addUserAnswerForWhatToDoNext_ShouldAddUWantsToSearchForAnotherRestaurant_WhenUserWantsToSearchForAnotherRestaurant {
    [_service startWithFeedbackRequest:NO];
    [self addRecognizedUserTextForSuggestionFeedback:@"I like it" intent:@"SuggestionFeedback_Like"];

    [self injectInterpretation:@"Search again" intent:@"WantsToSearchForAnotherRestaurant" entities:nil];
    [_service addUserText:@"Search again"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:WantsToSearchForAnotherRestaurant"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"Search again")));
}

- (void)test_addUserAnswerForWhatToDoNext_ShouldAddUGoodBye_WhenUserSaysGoodBye {
    [_service startWithFeedbackRequest:NO];
    [self addRecognizedUserTextForSuggestionFeedback:@"I like it" intent:@"SuggestionFeedback_Like"];

    [self injectInterpretation:@"No thanks!" intent:@"GoodBye" entities:nil];
    [_service addUserText:@"No thanks!"];

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:GoodBye"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"No thanks!")));
}

- (void)test_addUserVoiceForInputAction_ShouldAddUCuisinePreference_WhenAskUserCuisinePreferenceAction {
    [_service startWithFeedbackRequest:NO];

    [self injectInterpretation:@"I dislike American food" intent:@"SuggestionFeedback_DislikesKindOfFood" entities:nil];
    [_service addUserText:@"I dislike American food"];
    [self addRecognizedUserTextForCuisinePreference:@"I like Indian food" entities:@[[[SpeechEntity alloc] initWithType:@"food_type" value:@"Indian"]]];;

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:CuisinePreference=Indian"];
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.textSource, is(equalTo(@"I like Indian food")));
}

- (void)test_addUserOccasionPreferenceBreakfast_ShouldAddOccasionPreference {
    [self assertMappingForIntent:@"OccasionPreference" andEntities:@[[[SpeechEntity alloc] initWithType:@"meal_type" value:@"breakfast"]] mappedTo:@"U:OccasionPreference=breakfast"];
}

- (void)test_addUserOccasionPreferenceLunch_ShouldAddOccasionPreference {
    [self assertMappingForIntent:@"OccasionPreference" andEntities:@[[[SpeechEntity alloc] initWithType:@"meal_type" value:@"lunch"]] mappedTo:@"U:OccasionPreference=lunch"];
}

- (void)test_addUserOccasionPreferenceSnack_ShouldAddOccasionPreference {
    [self assertMappingForIntent:@"OccasionPreference" andEntities:@[[[SpeechEntity alloc] initWithType:@"meal_type" value:@"snack"]] mappedTo:@"U:OccasionPreference=snack"];
}

- (void)test_addUserOccasionPreferenceDinner_ShouldAddOccasionPreference {
    [self assertMappingForIntent:@"OccasionPreference" andEntities:@[[[SpeechEntity alloc] initWithType:@"meal_type" value:@"dinner"]] mappedTo:@"U:OccasionPreference=dinner"];
}

- (void)test_addUserOccasionPreferenceDrinks_ShouldAddOccasionPreference {
    [self assertMappingForIntent:@"OccasionPreference" andEntities:@[[[SpeechEntity alloc] initWithType:@"meal_type" value:@"drink"]] mappedTo:@"U:OccasionPreference=drink"];
}

- (void)test_addUserDislikesOccasion_ShouldAddSuggestionFeedbackDislike_WhenOccasionPreferenceUnknown {
    [_service startWithFeedbackRequest:NO];

    [self injectInterpretation:@"I want to have Indian" intent:@"CuisinePreference" entities:@[[[SpeechEntity alloc] initWithType:@"food_type" value:@"Indian"]]];
    [_service addUserText:@"I want to have Indian"]; // this removes Occasion Preference

    [self injectInterpretation:@"I dont't want to have dinner" intent:@"DislikesOccasion" entities:nil];
    [_service addUserText:@"I dont't want to have dinner"];  // since no Occasion is set this doesn't make sense, therefore we take it as a SuggestionFeedback=Dislike

    ConversationBubble *bubble = [self getBubbleWithSemanticId:@"U:SuggestionFeedback=Dislike"];
    assertThat(bubble, is(notNilValue()));
}

@end