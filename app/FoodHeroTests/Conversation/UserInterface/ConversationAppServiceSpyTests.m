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
#import "DefaultAssembly.h"
#import "ConversationBubbleUser.h"
#import "TyphoonComponents.h"
#import "ConversationAppService.h"
#import "StubAssembly.h"
#import "SpeechRecognitionServiceSpy.h"
#import "SpeechInterpretation.h"
#import "AskUserCuisinePreferenceAction.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "AskUserToTryAgainAction.h"
#import "AskUserWhatToDoNextAction.h"

@interface ConversationAppServiceSpyTests : XCTestCase

@end


@implementation ConversationAppServiceSpyTests {
    ConversationAppService *_service;
    SpeechRecognitionServiceSpy *_speechRecognitionService;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _speechRecognitionService = [SpeechRecognitionServiceSpy new];

    ConversationRepository *conversationRepo = [(id <ApplicationAssembly>) [TyphoonComponents factory] conversationRepository];
    RestaurantRepository *restaurantRepo = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantRepository];
    LocationService *locationService = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationService];
    _service = [[ConversationAppService alloc] initWithConversationRepository:conversationRepo restaurantRepository:restaurantRepo locationService:locationService speechRegocnitionService:_speechRecognitionService];
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

- (void)test_addUserText_ShouldUseAskForCuisinePreferenceState {
    [_service addUserText:@"I love indian food" forInputAction:[AskUserCuisinePreferenceAction new]];

    assertThat(_speechRecognitionService.lastState, is(equalTo(@"askForFoodPreference")));
}

- (void)test_addUserText_ShouldUseAskForSuggestionState {
    [self addRecognizedUserCuisinePreference:@"Indian food" entities:@[@"Indian"]];
    [_service addUserText:@"I hate it" forInputAction:[AskUserSuggestionFeedbackAction new]];

    assertThat(_speechRecognitionService.lastState, is(equalTo(@"askForSuggestionFeedback")));
}

- (void)test_addUserTextShouldNoRestaurantWasFoundState {
    [_service addUserText:@"Try again" forInputAction:[AskUserToTryAgainAction new]];

    assertThat(_speechRecognitionService.lastState, is(equalTo(@"noRestaurantWasFound")));
}

- (void)test_addUserText_ShouldUseAskForForWhatToDoNextState {
    [_service addUserText:@"Bye" forInputAction:[AskUserWhatToDoNextAction new]];

    assertThat(_speechRecognitionService.lastState, is(equalTo(@"askForWhatToDoNext")));
}

@end