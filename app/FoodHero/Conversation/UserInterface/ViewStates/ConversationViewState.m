//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Wit/WITMicButton.h>
#import "ConversationViewState.h"
#import "ConversationViewState+Protected.h"
#import "FoodHeroColors.h"
#import "ConversationViewController.h"

@implementation ConversationViewState

- (instancetype)initWithController:(ConversationViewController *)controller {
    self = [super init];
    if (self != nil) {
        _controller = controller;
    }
    return self;
}

- (void)update {

    // text input
    UITextField *userTextField = self.controller.userTextField;
    userTextField.enabled = self.isTextInputEnabled && _controller.isNotProcessingUserInput;
    userTextField.backgroundColor = userTextField.enabled ? nil : [FoodHeroColors lightestBackgroundGrey];

    // send-button
    NSString *text = userTextField.text;
    _controller.userSendButton.enabled =
            text.length > 0
                    && _controller.isNotProcessingUserInput;

    // list-button
    WITMicButton *micButton = self.controller.micButton;
    micButton.enabled =
            self.isUserInputListButtonEnabled
                    && (_controller.isNotProcessingUserInput || !_controller.isNotRecordingUserInput)
                    && _controller.recordPermission != AVAudioSessionRecordPermissionDenied;

    [self updateMicButtonColor:micButton.enabled];

    // help-button
    UIButton *helpButton = self.controller.helpButton;
    helpButton.enabled = _controller.isWaitingForUserInput && _controller.isNotProcessingUserInput;
}

- (void)updateMicButtonColor:(BOOL)inputAccepted {
    UIColor *color;
    NSNumber *lineWidth = _controller.isNotRecordingUserInput ? @(1.1) : @(2.8);
    if (_controller.recordPermission == AVAudioSessionRecordPermissionDenied) {
        color = [FoodHeroColors lightestDrawningGrey];
    }
    else if (inputAccepted) {
        color = [FoodHeroColors actionColor];
    }
    else {
        color = [FoodHeroColors lightestDrawningGrey];
    }
    WITMicButton *micButton = self.controller.micButton;
    micButton.innerCircleView.strokeColor = color;
    micButton.innerCircleView.lineWidth = lineWidth;

    micButton.outerCircleView.strokeColor = color;
    micButton.outerCircleView.lineWidth = lineWidth;

    micButton.volumeLayer.backgroundColor = color.CGColor;
}

- (void)activate {
    [self update];

    if (!self.isKeyboardVisible) {
        [self hideKeyboard];
    }
}

- (BOOL)isEqual:(id)other {
    return [[other class] isEqual:[self class]];
}

- (void)hideKeyboard {
    [self.controller hideKeyboard];
}

@end