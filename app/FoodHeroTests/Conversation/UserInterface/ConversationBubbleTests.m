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
#import "ConversationBubbleFoodHero.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "RestaurantBuilder.h"

@interface ConversationBubbleTests : XCTestCase

@end

@implementation ConversationBubbleTests {
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
}


- (ConversationBubbleFoodHero *)createBubbleWithStatement:(Statement *)statement {
    return [[ConversationBubbleFoodHero alloc] initWithStatement:statement width:100 index:0 doRenderSemanticID:NO];
}


- (void)test_textAsHtml_ShouldReturnTextWithoutLink_WhenNotASuggestion {

    Statement *statement = [Statement createWithSemanticId:@"FH:Greeting" text:@"Hello" state:nil suggestedRestaurant:nil expectedUserUtterances:nil];

    ConversationBubble *bubble = [self createBubbleWithStatement:statement];

    assertThat(bubble.textAsHtml, is(equalTo(@"Hello")));
}

- (void)test_textAsHtml_ShouldReturnTextWithLink_WhenSuggestion {
    Restaurant *restaurant = [[[RestaurantBuilder new] withName:@"Raj Palace"] build];
    Statement *statement = [Statement createWithSemanticId:@"FH:Greeting" text:@"This is a no brainer.  You should try %@." state:nil suggestedRestaurant:restaurant expectedUserUtterances:nil];

    ConversationBubble *bubble = [self createBubbleWithStatement:statement];

    assertThat(bubble.textAsHtml, is(equalTo(@"This is a no brainer.  You should try <a href=''>Raj Palace</a>.")));
}

@end
