//
//  WitSpeechRecognitionServiceIntegrationTests.m
//  FoodHero
//
//  Created by Jorg on 16/11/14.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XCAsyncTestCase/XCTestCase+AsyncTesting.h>
#import <OCHamcrest.h>
#import "TyphoonComponents.h"
#import "WitSpeechRecognitionService.h"
#import "SpeechInterpretation.h"
#import "IntegrationAssembly.h"
#import "AudioSessionStub.h"

@interface WitSpeechRecognitionServiceIntegrationTests : XCTestCase <ISpeechRecognitionStateSource>

@end

@implementation WitSpeechRecognitionServiceIntegrationTests {
    WitSpeechRecognitionService *_service;
    AudioSessionStub *_audioSessionStub;
    NSString *_state;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[IntegrationAssembly new]];
    _service = [(id <ApplicationAssembly>) [TyphoonComponents factory] speechRecognitionService];
    _service.stateSource = self;
    _audioSessionStub = [(id <ApplicationAssembly>) [TyphoonComponents factory] audioSession];
}

- (void)test_interpretString_ShouldReturnInterpretation_WhenStringMadeSense {
    NSMutableArray *interpretations = [NSMutableArray new];
    NSString *text = @"I want to eat Indian food";

    RACSignal *result = _service.output;
    _state = @"Test";
    [_service interpretString:text];

    // Assert
    [result subscribeNext:^(SpeechInterpretation *i) {
        [interpretations addObject:i];
        [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
    }];

    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10];

    assertThatInt(interpretations.count, is(equalTo(@1)));
    SpeechInterpretation *interpretation = interpretations[0];
    assertThatDouble(interpretation.confidence, is(greaterThan(@0)));
    assertThat(interpretation.text, is(equalTo(text)));
    assertThat(interpretation.intent, is(equalTo(@"CuisinePreference")));
    NSArray *entities = interpretation.entities;
    assertThatInt(entities.count, is(equalTo(@1)));
    assertThat(entities[0], is(equalTo(@"Indian")));
}

- (NSString *)getState {
    return _state;
}


@end
