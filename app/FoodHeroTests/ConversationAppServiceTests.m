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
#import "DefaultAssembly.h"
#import "ConversationBubbleUser.h"
#import "TyphoonComponents.h"
#import "ConversationAppService.h"

@interface ConversationAppServiceTests : XCTestCase

@end

const CGFloat portraitWidth = 200;
const CGFloat landscapeWidth = 400;

@implementation ConversationAppServiceTests
{
    ConversationAppService* _service;
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "objc_incompatible_pointers"
- (void)setUp
{
    [super setUp];

    [TyphoonComponents configure:[DefaultAssembly new]];
    _service =  [(DefaultAssembly *) [TyphoonComponents factory] conversationAppService];
}
#pragma clang diagnostic pop

- (ConversationBubble *)getStatement:(NSInteger)index
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
    [_service addStatement:@"British or Indian Food"];
    
    ConversationBubble *bubble = [self getStatement:1];
    
    assertThat(bubble, is(notNilValue()));
    assertThat(bubble.semanticId, is(equalTo(@"UserAnswer:British or Indian Food")));
    assertThat(bubble.class, is(equalTo(ConversationBubbleUser.class)));
}

@end