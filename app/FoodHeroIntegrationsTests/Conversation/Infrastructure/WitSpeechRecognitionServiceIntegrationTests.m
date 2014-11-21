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
#import "NoSpeechInterpretationError.h"

@interface WitSpeechRecognitionServiceIntegrationTests : XCTestCase

@end

@implementation WitSpeechRecognitionServiceIntegrationTests {
    WitSpeechRecognitionService *_service;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[IntegrationAssembly new]];
    _service = [(id <ApplicationAssembly>) [TyphoonComponents factory] speechRecognitionService];
}

- (void)test_interpretString_ShouldReturnInterpretation_WhenStringMadeSense {
    NSMutableArray *interpretations = [NSMutableArray new];
    NSString *text = @"I want to eat Indian food";

    RACSignal *result = [_service interpretString:text customData:nil];

    // Assert
    [result subscribeNext:^(SpeechInterpretation *i) {
        [interpretations addObject:i];
    }];

    [result subscribeCompleted:^() {
        [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
    }];

    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10];

    assertThatInt(interpretations.count, is(equalTo(@1)));
    SpeechInterpretation *interpretation = interpretations[0];
    assertThatDouble(interpretation.confidence, is(greaterThan(@0)));
    assertThat(interpretation.text, is(equalTo(text)));
    assertThat(interpretation.intent, is(equalTo(@"setFoodPreference")));
    NSArray *entities = interpretation.entities;
    assertThatInt(entities.count, is(equalTo(@1)));
    assertThat(entities[0], is(equalTo(@"Indian")));
}


- (void)test_interpretString_ShouldReturnError_WhenWitCantBeReached {
    id schedulers = [(id <ApplicationAssembly>) [TyphoonComponents factory] schedulerFactory];
    NSString *invalidToken = @"asdhf82q3z0483q148";
    WitSpeechRecognitionService *service = [[WitSpeechRecognitionService alloc] initWithSchedulerFactory:schedulers accessToken:invalidToken];

    RACSignal *result = [service interpretString:@"Funny text" customData:nil];

    __block NSError *error = nil;
    [result subscribeError:^(NSError *e) {
        error = e;
        [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
    }];

    __block BOOL completed = NO;
    [result subscribeCompleted:^() {
        completed = YES;
        [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
    }];

    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10];

    assertThat(error.class, is(equalTo(NoSpeechInterpretationError.class)));
    assertThatBool(completed, is(equalToBool(NO)));
}

@end