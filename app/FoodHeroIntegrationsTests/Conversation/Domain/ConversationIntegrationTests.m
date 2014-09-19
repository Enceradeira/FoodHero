//
//  ConversationIntegrationTests.m
//  FoodHero
//
//  Created by Jorg on 18/09/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XCAsyncTestCase/XCTestCase+AsyncTesting.h>
#import <OCHamcrest.h>
#import "TyphoonComponents.h"
#import "Conversation.h"
#import "TextRepository.h"
#import "RandomizerStub.h"
#import "IntegrationAssembly.h"

@interface ConversationIntegrationTests : XCTestCase

@end

@implementation ConversationIntegrationTests {
    RandomizerStub *_randomizer;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[IntegrationAssembly new]];

    _randomizer = [(id <ApplicationAssembly>) [TyphoonComponents factory] randomizer];
}

- (Conversation *)createConversation {
    return [(id <ApplicationAssembly>) [TyphoonComponents factory] conversation];
}

- (void)test_FHGreetingShouldPlaySound_WhenTired {
    [_randomizer injectChoiceForOneText:@"I’m tired.  I need coffee before I can continue."];

    Conversation *conversation = [self createConversation];
    [conversation.statementIndexes subscribeNext:^(id next) {
        if ([conversation getStatementCount] == 2) {
            [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
        }
    }];

    // while waiting a sound should be played and two statements should have been produced
    [self XCA_waitForTimeout:30];

    Statement *greeting = [conversation getStatement:0];
    Statement *openingQuestion = [conversation getStatement:1];

    assertThat(greeting.token.semanticId, is(equalTo(@"FH:Greeting")));
    assertThat(openingQuestion.token.semanticId, is(equalTo(@"FH:OpeningQuestion")));
}

- (void)test_FHGreetingShouldPlaySound_WhenListeningToMusic{
    [_randomizer injectChoiceForOneText:@"Just a moment..."];

    Conversation *conversation = [self createConversation];
    [conversation.statementIndexes subscribeNext:^(id next) {
        if ([conversation getStatementCount] == 3) {
            [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
        }
    }];

    // while waiting a sound should be played and two statements should have been produced
    [self XCA_waitForTimeout:30];

    Statement *justAMoment = [conversation getStatement:0];
    Statement *sorryIWasListening = [conversation getStatement:1];
    Statement *openingQuestion = [conversation getStatement:2];

    assertThat(justAMoment.token.semanticId, is(equalTo(@"FH:Greeting")));
    assertThat(sorryIWasListening.token.semanticId, is(equalTo(@"FH:Greeting")));
    assertThat(openingQuestion.token.semanticId, is(equalTo(@"FH:OpeningQuestion")));
}

@end
