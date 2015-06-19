//
//  ConversationViewControllerTests.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Typhoon.h>
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

    _ctrl = [ControllerFactory createConversationViewController];
    _ctrl.view.hidden = NO;
    _bubbleView = _ctrl.bubbleView;
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

- (void)test_getTextForSharing_ShouldReturnNicelyFormattedText_WhenRestaurantSuggested {
    NSString *text = [_ctrl getTextForSharing];

    assertThat(text, is(equalTo(@"Food Hero said:\n\nThis is a no brainer.  You should try King's Head.\nnamaste.co.uk\n\nDownload Food Hero from www.jennius.co.uk")));
}

@end
