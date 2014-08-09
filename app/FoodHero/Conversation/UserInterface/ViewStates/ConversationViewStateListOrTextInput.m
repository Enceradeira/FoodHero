//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewStateListOrTextInput.h"
#import "ConversationViewState+Protected.h"
#import "ViewDimensionHelper.h"


@implementation ConversationViewStateListOrTextInput {

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
    return [[ConversationViewStateListOrTextInput alloc] initWithController:controller animationDuration:animationDuration animationCurve:animationCurve];
}

- (void)activate {
    [super activate];

    ViewDimensionHelper *viewDimensionHelper = _controller.viewDimensions;
    _controller.userInputHeightConstraint.constant = viewDimensionHelper.userInputListHeight;
    _controller.userInputHeaderHeightConstraint.constant = viewDimensionHelper.userInputHeaderHeight;
    _controller.bubbleViewHeightConstraint.constant = viewDimensionHelper.bubbleViewHeight;

    [self animateLayoutWithDuration:_animationDuration animationCurve:_animationCurve];
}

- (BOOL)isKeyboardVisible {
    return NO;
}

- (BOOL)isTextInputEnabled {
    return YES;
}

@end