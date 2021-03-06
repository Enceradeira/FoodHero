//
//  ConversationViewControllerTests.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Typhoon/Typhoon.h>
#import "ConversationViewController.h"
#import "ControllerFactory.h"
#import "ConversationBubbleTableViewCell.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "IAudioSession.h"

@interface ConversationViewControllerTests : XCTestCase

@end

@implementation ConversationViewControllerTests {
    ConversationViewController *_ctrl;
    UITableView *_bubbleView;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly assembly]];

    ConversationAppService *appService = [[TyphoonComponents getAssembly] conversationAppService];
    _ctrl = [ControllerFactory createConversationViewController];
    _ctrl.view.hidden = NO;
    _bubbleView = _ctrl.bubbleView;

    [appService startWithFeedbackRequest:YES];
}

- (ConversationBubbleTableViewCell *)assertRow:(NSUInteger)index {
    NSInteger num = [_bubbleView numberOfRowsInSection:0]; // this forces the cells to be loaded somehow
    assertThatInteger(num, is(greaterThan(@(index))));
    ConversationBubbleTableViewCell *userAnswer = (ConversationBubbleTableViewCell *) [_bubbleView visibleCells][index];
    assertThat(userAnswer, is(notNilValue()));
    assertThat(userAnswer.bubble, is(notNilValue()));
    return userAnswer;
}

- (void)test_Controller_ShouldInitializeConversationBubbleView {
    assertThat(_bubbleView, is(notNilValue()));
}

- (void)test_Controller_ShouldGreetUserOnFirstRow {
    ConversationBubbleTableViewCell *firstRow = [self assertRow:0];

    assertThat(firstRow.bubble.semanticId, containsString(@"FH:Greeting"));
}

@end
