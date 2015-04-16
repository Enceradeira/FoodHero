//
//  ConversationAppServiceIntegrationTests.m
//  FoodHero
//
//  Created by Jorg on 16/11/14.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <XCAsyncTestCase/XCTestCase+AsyncTesting.h>
#import "ApplicationAssembly.h"
#import "TyphoonComponents.h"
#import "ConversationAppService.h"
#import "ConversationBubbleUser.h"
#import "IntegrationAssembly.h"
#import "CLLocationManagerProxyStub.h"
#import "FoodHero-Swift.h"

@interface ConversationAppServiceIntegrationTests : XCTestCase <ISpeechRecognitionStateSource>

@end

@implementation ConversationAppServiceIntegrationTests {
    ConversationAppService *_service;
    NSString *_currState;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[IntegrationAssembly new]];

    id <ApplicationAssembly> factory = (id <ApplicationAssembly>) [TyphoonComponents getAssembly];
    _service = [factory conversationAppService];

    // Setup LocationManager
    id locationManagerProxy = [factory locationManagerProxy];
    CLLocation *london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];
    [locationManagerProxy injectLocations:@[london]];

    // Setup SpeechRecognition
    _service.stateSource = self;
}

- (ConversationBubble *)getStatementWithIndex:(NSUInteger)index {
    ConversationBubble *bubble = [_service getStatement:index bubbleWidth:350];
    return bubble;
}

- (ConversationBubble *)waitStatementWithIndex:(NSUInteger)index {
    [_service.statementIndexes subscribeNext:^(id next) {
        if ([_service getStatementCount] > index) {
            [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
        }
    }];
    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10];
    [self XCA_notify:XCTAsyncTestCaseStatusUnknown]; // reset in order that we can wait again
    return [self getStatementWithIndex:index];
}

- (void)test_addUserCuisinePreference_ShouldAddUCuisinePreferenceToConversation {
    _currState = [FHStates askForFoodPreference];
    [_service addUserText:@"I whished to eat Korean food"];

    ConversationBubble *bubble = [self waitStatementWithIndex:1];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.semanticId, is(equalTo(@"U:CuisinePreference=Korean")));
    assertThat(bubble.class, is(equalTo(ConversationBubbleUser.class)));
}

- (NSString *)getState {
    return _currState;
}

- (void)didStopProcessingUserInput {

}

- (void)didStartProcessingUserInput {

}


@end
