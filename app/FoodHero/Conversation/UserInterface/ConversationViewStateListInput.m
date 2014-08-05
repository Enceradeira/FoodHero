//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewStateListInput.h"
#import "ConversationViewController.h"
#import "ViewDimensions.h"


@implementation ConversationViewStateListInput {

    ConversationViewController *_controller;
    NSTimeInterval _animationDuration;
    UIViewAnimationCurve _animationCurve;
}

- (instancetype)initWithController:(ConversationViewController *)controller animationDuration:(NSTimeInterval)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve {
    self = [super initWithController:controller];
    if (self != nil) {
        _controller = controller;
        _animationDuration = animationDuration;
        _animationCurve = animationCurve;
    }
    return self;
}

+ (instancetype)create:(ConversationViewController *)controller animationDuration:(NSTimeInterval)animationDuration animationCurve:(enum UIViewAnimationCurve)animationCurve {
    return [[ConversationViewStateListInput alloc] initWithController:controller animationDuration:animationDuration animationCurve:animationCurve];
}

- (void)animateChange {
    [super hideKeyboard];
    // [super adjustViewsForKeyboardHeight:0 animationDuration:0 animationCurve:UIViewAnimationCurveLinear];

    CGRect viewFrame = _controller.view.frame;
    CGFloat viewHeight = viewFrame.size.height; // current height of the top most container view


    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:_animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve) _animationCurve];
    _controller.bubbleView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, viewHeight - UserInputHeaderHeight - UserInputListHeight);
    _controller.userInputView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y + _controller.bubbleView.frame.size.height, viewFrame.size.width, UserInputHeaderHeight + UserInputListHeight);
    [UIView commitAnimations];
}

@end