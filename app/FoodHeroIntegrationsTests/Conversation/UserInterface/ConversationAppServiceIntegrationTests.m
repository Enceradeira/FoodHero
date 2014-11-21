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

@interface ConversationAppServiceIntegrationTests : XCTestCase

@end

@implementation ConversationAppServiceIntegrationTests {
    ConversationAppService *_service;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[IntegrationAssembly new]];

    id <ApplicationAssembly> factory = (id <ApplicationAssembly>) [TyphoonComponents factory];
    _service = [factory conversationAppService];

    id locationManagerProxy = [factory locationManagerProxy];
    CLLocation *london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];
    [locationManagerProxy injectLocations:@[london]];
}

- (ConversationBubble *)getStatementWithIndex:(NSUInteger)index {
    ConversationBubble *bubble = [_service getStatement:index bubbleWidth:350];
    return bubble;
}

- (ConversationBubble *)waitStatementWithIndex:(NSUInteger)index {
    [_service.statementIndexes subscribeNext:^(id next) {
        if ([_service getStatementCount]  > index) {
            [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
        }
    }];
    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10];
    [self XCA_notify:XCTAsyncTestCaseStatusUnknown]; // reset in order that we can wait again
    return [self getStatementWithIndex:index];
}

- (void)test_addUserCuisinePreference_ShouldAddUCuisinePreferenceToConversation {
    [_service addUserCuisinePreference:@"I whished to eat Korean food"];

    ConversationBubble *bubble = [self waitStatementWithIndex:2];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.semanticId, is(equalTo(@"U:CuisinePreference=Korean")));
    assertThat(bubble.class, is(equalTo(ConversationBubbleUser.class)));
}

- (void)test_addUserSuggestionFeedback_ShouldAddUSuggestionFeedbackToConversation {
    [_service addUserCuisinePreference:@"I wished to eat Indian food"];
    [self waitStatementWithIndex:3];

    [_service addUserSuggestionFeedback:@"It's too far away"];
    ConversationBubble *bubble = [self waitStatementWithIndex:4];

    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.semanticId, is(equalTo(@"U:SuggestionFeedback=tooFarAway")));
    assertThat(bubble.class, is(equalTo(ConversationBubbleUser.class)));
}

@end
