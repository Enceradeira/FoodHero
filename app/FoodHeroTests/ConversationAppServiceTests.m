//
//  ConversationAppServiceTests.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import <Typhoon.h>
#import "TyphoonBuilder.h"
#import "ApplicationAssembly.h"
#import "ConversationAppService.h"
#import "ConversationBubble.h"
#import "ConversationBubbleFoodHero.h"
#import "ConversationBubbleUser.h"
#import "DesignByContractException.h"

@interface ConversationAppServiceTests : XCTestCase

@end

const CGFloat portraitWidth = 200;
const CGFloat landscapeWidth = 400;

@implementation ConversationAppServiceTests
{
    ConversationAppService* _service;

}

- (void)setUp
{
    [super setUp];
    
    TyphoonComponentFactory *factory = [TyphoonBuilder createFactory:[ApplicationAssembly new]];
    _service =  [(ApplicationAssembly*)factory conversationAppService ];
}

- (ConversationBubble *)getStatement:(NSInteger)index
{
    ConversationBubble *bubble1 = [_service getStatement:index bubbleWidth:portraitWidth];
    return bubble1;
}

- (void)test_getFirstStatement_ShouldReturnFoodHerosGreeting
{
    ConversationBubble *bubble = [self getStatement:0];
    
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.semanticId, is(equalTo(@"Greeting&OpeningQuestion")));
    assertThat(bubble.class, is(equalTo(ConversationBubbleFoodHero.class)));
    
}

- (void)test_getFirstStatement_ShouldAlwaysReturnSameInstanceOfBubble
{
    ConversationBubble *bubble1 = [self getStatement:0];
    ConversationBubble *bubble2 = [self getStatement:0];
    
    assertThat(bubble1, is(sameInstance(bubble2)));
}

- (void)test_getFirstStatement_ShouldReturnDifferentInstanceOfBubble_WhenWidthChanges
{
    ConversationBubble *bubble1 = [_service getStatement:0 bubbleWidth:portraitWidth];
    ConversationBubble *bubble2 = [_service getStatement:0 bubbleWidth:landscapeWidth];
    
    assertThat(bubble1, isNot(sameInstance(bubble2)));
}

- (void)test_getSecondStatement_ShouldReturnException_WhenHasNeverSaidAnything
{
    @try {
        [self getStatement:1];
        XCTFail(@"An exception must be thrown");
    }
    @catch (DesignByContractException *exception)
    {
    }
}

-(void)test_getSecondStatement_ShouldReturnUserAnswer_WhenUserHasSaidSomething
{
    [_service addStatement:@"British or Indian Food"];
    
    ConversationBubble *bubble = [self getStatement:1];
    
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.semanticId, is(equalTo(@"UserAnswer:British or Indian Food")));
    assertThat(bubble.class, is(equalTo(ConversationBubbleUser.class)));
}

-(void)test_getStatementCount_ShouldReturnNrOfStatementsInConversation
{
    assertThatInteger([_service getStatementCount], is(equalToInteger(1)));
    
    [_service addStatement:@"British or Indian Food"];
    assertThatInteger([_service getStatementCount], is(equalToInteger(2)));
    
    [_service addStatement:@"It's too far away"];
    assertThatInteger([_service getStatementCount], is(equalToInteger(3)));
}

@end