//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewState.h"
#import "ConversationViewController.h"
#import "DesignByContractException.h"


const int InputViewHeight = 100;

@implementation ConversationViewState {
    ConversationViewController *_controller;
}

- (instancetype)initWithController:(ConversationViewController *)controller {
    self = [super init];
    if (self != nil) {
        _controller = controller;
    }
    return self;
}

- (void)adjustViewsForKeyboardHeight:(CGFloat)keyboardHeight animationDuration:(double)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve {

    CGRect viewFrame = _controller.view.frame;
    CGFloat viewHeight = viewFrame.size.height; // current height of the top most container view

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve) animationCurve];
    _controller.bubbleView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, viewHeight - InputViewHeight - keyboardHeight);
    _controller.userInputView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y + _controller.bubbleView.frame.size.height, viewFrame.size.width, InputViewHeight);
    [UIView commitAnimations];
}

- (void)hideKeyboard {
    [_controller hideKeyboard];
}

- (void)animateChange {
    @throw [DesignByContractException createWithReason:@"base class must override this method"];
}


@end