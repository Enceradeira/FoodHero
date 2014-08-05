//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewState.h"
#import "ConversationViewController.h"
#import "DesignByContractException.h"
#import "ViewDimensions.h"

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

- (void)adjustViewsForKeyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve {

    _controller.userInputListHeightConstraint.constant = 0;
    _controller.userInputHeaderHeightConstraint.constant = UserInputHeaderHeight;
    // bubbleView gets the space from the hidden userInputList but is shortened by keyboardHeight
    _controller.bubbleViewHeightConstraint.constant = BubbleViewHeight + UserInputListHeight - keyboardHeight ;


    [self animateLayoutWithDuration:animationDuration animationCurve:animationCurve];
}

- (void)animateLayoutWithDuration:(NSTimeInterval)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve {
    [UIView animateWithDuration:animationDuration delay:0.0 options:[self animationCurveToAnimationOption:animationCurve] animations:^{
        [_controller.view layoutIfNeeded];
    }                completion:^(BOOL b){
    }];
}

- (UIViewAnimationOptions)animationCurveToAnimationOption:(UIViewAnimationCurve)curve {
    return (UIViewAnimationOptions) (curve << 16);
}

- (void)hideKeyboard {
    [_controller hideKeyboard];
}

- (void)animateChange {
    @throw [DesignByContractException createWithReason:@"base class must override this method"];
}

- (BOOL)isEqual:(id)other {
    return [[other class] isEqual:[self class]];
}


@end