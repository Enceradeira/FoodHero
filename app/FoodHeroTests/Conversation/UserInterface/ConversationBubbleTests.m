//
//  ConversationBubbleTests.m
//  FoodHero
//
//  Created by Jorg on 02/10/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest.h>
#import "ConversationBubble.h"
#import "FHGreeting.h"
#import "ConversationBubbleFoodHero.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "FHSuggestion.h"
#import "RestaurantBuilder.h"

@interface ConversationBubbleTests : XCTestCase

@end

@implementation ConversationBubbleTests {
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
}


- (ConversationBubbleFoodHero *)createBubbleWithToken:(ConversationToken *)token {
    Statement *statement = [Statement create:token state:nil];
    return [[ConversationBubbleFoodHero alloc] initWithStatement:statement width:100 index:0 doRenderSemanticID:NO];
}


- (void)test_textAsHtml_ShouldReturnTextWithoutLink_WhenNotASuggestion {
    ConversationBubble *bubble = [self createBubbleWithToken:[FHGreeting create]];

    assertThat(bubble.textAsHtml, is(equalTo(@"Hello")));
}

- (void)test_textAsHtml_ShouldReturnTextWithLink_WhenSuggestion {
    Restaurant *restaurant = [[[RestaurantBuilder new] withName:@"Raj Palace"] build];
    ConversationBubble *bubble = [self createBubbleWithToken:[FHSuggestion create:restaurant]];

    assertThat(bubble.textAsHtml, is(equalTo(@"This is a no brainer.  You should try <a href=''>Raj Palace</a>.")));
}

@end
