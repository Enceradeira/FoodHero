//
//  ConversationTests.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "Conversation.h"
#import "Personas.h"
#import "DesignByContractException.h"

@interface ConversationTests : XCTestCase

@end

@implementation ConversationTests
{
    Conversation *_conversation;
}
- (void)setUp
{
    [super setUp];
    
    _conversation = [Conversation new];
}

- (void)test_getStatement_ShouldHaveFoodHerosGreeting_WhenAskedForFirst
{
    Statement *statement = [_conversation getStatement:0];
    
    assertThat(statement, is(notNilValue()));
    assertThat(statement.semanticId, is(equalTo(@"Greeting&OpeningQuestion")));
    assertThat(statement.persona, is(equalTo(Personas.foodHero)));
}

- (void)test_getStatement_ShouldReturnException_WhenUserHasNeverSaidAnythingAndWhenAskedForSecondStatement
{
    @try {
        [_conversation getStatement:1];
        XCTFail(@"An exception must be thrown");
    }
    @catch (DesignByContractException *exception)
    {
    }
}

-(void)test_getStatement_ShouldReturnUserAnswer_WhenUserHasSaidSomething
{
    [_conversation addStatement:@"British or Indian Food"];
    
    Statement *statement  = [_conversation getStatement:1];
    
    assertThat(statement, is(notNilValue()));
    assertThat(statement.semanticId, is(equalTo(@"UserAnswer:British or Indian Food")));
    assertThat(statement.persona, is(equalTo(Personas.user)));
}

-(void)test_getStatementCount_ShouldReturnNrOfStatementsInConversation
{
    assertThatInteger([_conversation getStatementCount], is(equalToInteger(1)));
    
    [_conversation addStatement:@"British or Indian Food"];
    assertThatInteger([_conversation getStatementCount], is(equalToInteger(2)));
    
    [_conversation addStatement:@"It's too far away"];
    assertThatInteger([_conversation getStatementCount], is(equalToInteger(3)));
}

@end
