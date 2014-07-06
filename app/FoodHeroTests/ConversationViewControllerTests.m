//
//  ConversationViewControllerTests.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import <Typhoon.h>
#import "ConversationViewController.h"
#import "ApplicationAssembly.h"
#import "ControllerFactory.h"
#import "ConversationBubbleTableViewCell.h"

@interface ConversationViewControllerTests : XCTestCase

@end

@implementation ConversationViewControllerTests
{
    ConversationViewController *_ctrl;
}

- (void)setUp
{
    [super setUp];
    
    TyphoonAssembly* assembly = [ApplicationAssembly assembly];
    _ctrl= [ControllerFactory createConversationViewController:assembly];
    
    _ctrl.view.hidden = NO;
}

- (void)test_Controller_ShouldInitializeConversationBubbleView
{
    assertThat(_ctrl.conversationBubbleView, is(notNilValue()));
}

- (void)test_Controller_ShouldGreatUserOnFirstRow
{
    UITableView *bubbleView = (UITableView*)_ctrl.conversationBubbleView;
   
    NSInteger num = [bubbleView numberOfRowsInSection:0]; // this forces the cells to be loaded somehose
    assertThatInteger(num, is(equalToInteger(1)));
    
    ConversationBubbleTableViewCell* firstRow = (ConversationBubbleTableViewCell*)[bubbleView visibleCells][0];
    
    assertThat(firstRow, is(notNilValue()));
    assertThat(firstRow.bubble, is(notNilValue()));
    assertThat(firstRow.bubble.semanticId, is(equalTo(@"Greeting&OpeningQuestion")));
}

-(void)test_Controller_ShouldRedrawFoodHerosBubble_WhenRotated
{
    
}

@end
