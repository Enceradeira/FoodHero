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
#import "DefaultAssembly.h"
#import "ControllerFactory.h"
#import "ConversationBubbleTableViewCell.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "SpeechRecognitionServiceStub.h"
#import "SpeechInterpretation.h"

@interface ConversationViewControllerTests : XCTestCase

@end

@implementation ConversationViewControllerTests {
    ConversationViewController *_ctrl;
    UITableView *_bubbleView;
    SpeechRecognitionServiceStub *_speechRegocnitionService;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly assembly]];
    _ctrl = [ControllerFactory createConversationViewController];
    _speechRegocnitionService = ((id <ApplicationAssembly>) [TyphoonComponents factory]).speechRecognitionService;

    _ctrl.view.hidden = NO;
    _bubbleView = _ctrl.bubbleView;
}

- (void)injectInterpretation:(NSString *)text intent:(NSString *)intent entities:(NSArray *)entities {
    SpeechInterpretation *interpretation = [SpeechInterpretation new];
    interpretation.intent = intent;
    interpretation.text = text;
    interpretation.entities = entities;
    [_speechRegocnitionService injectInterpretation:interpretation];
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

- (void)test_Controller_ShouldGreatUserOnFirstRow {
    ConversationBubbleTableViewCell *firstRow = [self assertRow:0];

    assertThat(firstRow.bubble.semanticId, is(equalTo(@"FH:Greeting")));
}

- (void)test_userMicButtonTouchUp_ShouldDisableInputDuringProcessing {
    [_ctrl userTextField].text = @"ahhm";  // in order that send-button enables
    [_ctrl userMicButtonTouchUp:self];

    assertThatBool(_ctrl.userMicButton.enabled, is(equalToBool(NO)));
    assertThatBool(_ctrl.userTextField.enabled, is(equalToBool(NO)));
    assertThatBool(_ctrl.userSendButton.enabled, is(equalToBool(NO)));

    [self injectInterpretation:@"I want Indian food" intent:@"setFoodPreference" entities:@[@"Indian"]];

    assertThatBool(_ctrl.userMicButton.enabled, is(equalToBool(YES)));
    assertThatBool(_ctrl.userTextField.enabled, is(equalToBool(YES)));
    assertThatBool(_ctrl.userSendButton.enabled, is(equalToBool(NO))); // because userTextField is empty now
}

- (void)test_userMicButtonTouchUp_ShouldAddNewConversationBubble {
    NSUInteger bubbleCount = [_bubbleView visibleCells].count;

    [_ctrl userMicButtonTouchUp:self];
    [self injectInterpretation:@"I want Indian food" intent:@"setFoodPreference" entities:@[@"Indian"]];

    assertThatInt([_bubbleView visibleCells].count, is(greaterThan(@(bubbleCount))));
}
@end
