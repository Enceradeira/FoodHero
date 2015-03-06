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
#import "IAudioSession.h"
#import "AudioSessionStub.h"

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

    assertThat(firstRow.bubble.semanticId, is(equalTo(@"FH:Greeting;FH:OpeningQuestion")));
}

- (void)test_userMicButtonTouchUp_ShouldAddNewConversationBubble {
    NSUInteger bubbleCount = [_bubbleView visibleCells].count;

    [self injectInterpretation:@"I want Indian food" intent:@"setFoodPreference" entities:@[@"Indian"]];
    [_ctrl userMicButtonTouchUp:self];
    
    assertThatInt([_bubbleView visibleCells].count, is(greaterThan(@(bubbleCount))));
}


-(void)test_Controller_ShouldDisableMicButton_WhenNoPermissionForMicrophone{
    [_speechRegocnitionService injectRecordPermission:AVAudioSessionRecordPermissionDenied];

    _ctrl = [ControllerFactory createConversationViewController];
    _ctrl.view.hidden = NO;

    assertThatBool(_ctrl.userMicButton.enabled, is(@(NO)));
}

-(void)test_Controller_ShouldEnableMicButton_WhenPermissionForMicrophone{
    [_speechRegocnitionService injectRecordPermission:AVAudioSessionRecordPermissionGranted];

    _ctrl = [ControllerFactory createConversationViewController];
    _ctrl.view.hidden = NO;


    assertThatBool(_ctrl.userMicButton.enabled, is(@(YES)));
}

-(void)test_Controller_ShouldEnableMicButton_WhenUnknownPermissionForMicrophone{
    [_speechRegocnitionService injectRecordPermission:AVAudioSessionRecordPermissionUndetermined];

    _ctrl = [ControllerFactory createConversationViewController];
    _ctrl.view.hidden = NO;


    assertThatBool(_ctrl.userMicButton.enabled, is(@(YES)));
}
@end
