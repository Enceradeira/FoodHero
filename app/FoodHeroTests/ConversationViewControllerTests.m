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

- (ConversationBubbleTableViewCell *)assertLastRow:(UITableView *)bubbleView expectedNrOfRows:(NSInteger) expectedNrOfRows
{
    NSInteger num = [bubbleView numberOfRowsInSection:0]; // this forces the cells to be loaded somehow
    assertThatInteger(num, is(equalToInteger(expectedNrOfRows)));
    ConversationBubbleTableViewCell* userAnswer = (ConversationBubbleTableViewCell*)[bubbleView visibleCells][expectedNrOfRows-1];
    return userAnswer;
}

- (void)test_Controller_ShouldInitializeConversationBubbleView
{
    assertThat(_ctrl.conversationBubbleView, is(notNilValue()));
}

- (void)test_Controller_ShouldGreatUserOnFirstRow
{
    UITableView *bubbleView = (UITableView*)_ctrl.conversationBubbleView;
   
    ConversationBubbleTableViewCell *firstRow = [self assertLastRow:bubbleView expectedNrOfRows:1];
    
    assertThat(firstRow, is(notNilValue()));
    assertThat(firstRow.bubble, is(notNilValue()));
    assertThat(firstRow.bubble.semanticId, is(equalTo(@"Greeting&OpeningQuestion")));
}


-(void)test_Controller_ShouldDisplayUserAnswerOnSecondRow
{
    UITableView *bubbleView = (UITableView*)_ctrl.conversationBubbleView;
    
    [_ctrl userChoosesIndianOrBritishFood:self];
    
    ConversationBubbleTableViewCell *userAnswer = [self assertLastRow:bubbleView expectedNrOfRows:2];
    
    assertThat(userAnswer, is(notNilValue()));
    assertThat(userAnswer.bubble, is(notNilValue()));
    assertThat(userAnswer.bubble.semanticId, is(equalTo(@"UserAnswer:British or Indian food")));
}

@end
