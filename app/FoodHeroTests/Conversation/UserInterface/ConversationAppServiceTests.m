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
#import "ConversationToken.h"
#import "UCuisinePreference.h"

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

    [TyphoonComponents configure:[StubAssembly new]];
    _service =  [(id<ApplicationAssembly>) [TyphoonComponents factory] conversationAppService];
}

- (ConversationBubble *)getStatement:(NSUInteger)index
{
    ConversationBubble *bubble = [_service getStatement:index bubbleWidth:portraitWidth];
    return bubble;
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

-(void)test_getSecondStatement_ShouldReturnUserAnswer_WhenUserHasSaidSomething
{
    id userInput = [UCuisinePreference create:@"British or Indian Food"];
    [_service addUserInput:userInput];
    
    ConversationBubble *bubble = [self getStatement:1];
    
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.semanticId, is(equalTo(@"U:CuisinePreference=British or Indian Food")));
    assertThat(bubble.class, is(equalTo(ConversationBubbleUser.class)));
}

-(void)test_getCuisineCount_ShouldReturnCountGreaterThan0
{
    assertThatInteger([_service getCuisineCount], is(greaterThan(@0)));
}

-(void)test_getCuisine_ShouldReturnCuisineForIndex
{
    NSString* cuisine0 = [_service getCuisine:0];
    NSString* cuisine1 = [_service getCuisine:1];

    assertThatInteger(cuisine0.length, is(greaterThan(@0)));
    assertThatInteger(cuisine1.length, is(greaterThan(@0)));
    assertThat(cuisine0, isNot(equalTo(cuisine1)));
}

@end