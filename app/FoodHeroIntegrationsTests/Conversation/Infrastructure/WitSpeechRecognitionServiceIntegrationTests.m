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
#import "FoodHero-Swift.h"

@interface WitSpeechRecognitionServiceIntegrationTests : XCTestCase <ISpeechRecognitionStateSource>

@end

@implementation WitSpeechRecognitionServiceIntegrationTests {
    WitSpeechRecognitionService *_service;
    AudioSessionStub *_audioSessionStub;
    NSString *_state;
    BOOL _isProcessingUserInput;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[IntegrationAssembly new]];
    _service = [[TyphoonComponents getAssembly] speechRecognitionService];
    _service.stateSource = self;
    _audioSessionStub = [[TyphoonComponents getAssembly] audioSession];
}

- (NSArray *)interpretString:(NSString *)text {
    NSMutableArray *interpretations = [NSMutableArray new];
    RACSignal *result = _service.output;
    _state = @"Test";
    [_service interpretString:text];
    assertThatBool(_isProcessingUserInput, isTrue());

    // Assert
    [result subscribeNext:^(SpeechInterpretation *i) {
        [interpretations addObject:i];
        [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
    }];

    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10];
    assertThatBool(_isProcessingUserInput, isFalse());
    return interpretations;
}

- (void)test_interpretString_ShouldDecodeLocation {
    NSString *text = @"I want a french restaurant in Diss";

    NSArray *interpretations = [self interpretString:text];

    assertThatInt(interpretations.count, is(equalTo(@1)));
    SpeechInterpretation *interpretation = interpretations[0];
    assertThat(interpretation.intent, is(equalTo(@"CuisinePreference")));
    NSArray *entities = interpretation.entities;
    assertThatInt(entities.count, is(equalTo(@2)));
    SpeechEntity *entity1 = entities[0];
    assertThat(entity1.type, is(equalTo(@"food_type")));
    assertThat(entity1.value, is(equalTo(@"French")));
    SpeechEntity *entity2 = entities[1];
    assertThat(entity2.type, is(equalTo(@"location")));
    assertThat(entity2.value, is(equalTo(@"Diss")));
}

- (NSString *)getState {
    return _state;
}

- (ExpectedUserUtterances *)expectedUserUtterances {
    return nil;
}

- (void)didStopRecordingUserInput {

}

- (void)didStartRecordingUserInput {

}

- (void)didStopProcessingUserInput {
    _isProcessingUserInput = NO;
}

- (void)didStartProcessingUserInput {
    _isProcessingUserInput = YES;
}


@end
