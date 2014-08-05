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

    _controller.userInputListHeightConstraint.constant = UserInputListHeight;
    _controller.userInputHeaderHeightConstraint.constant = UserInputHeaderHeight;
    _controller.bubbleViewHeightConstraint.constant = BubbleViewHeight;

    [self animateLayoutWithDuration:_animationDuration animationCurve:_animationCurve];
}

@end