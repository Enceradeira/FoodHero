//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewState+Protected.h"
#import "ViewDimensionHelper.h"


@implementation ConversationViewState (Protected)

- (void)adjustViewsForKeyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve {

    ViewDimensionHelper *viewDimensionHelper = self.controller.viewDimensionHelper;

    self.controller.userInputListHeightConstraint.constant = 0;
    self.controller.userInputHeaderHeightConstraint.constant = viewDimensionHelper.userInputHeaderHeight;
    // bubbleView gets the space from the hidden userInputList but is shortened by keyboardHeight
    self.controller.bubbleViewHeightConstraint.constant = viewDimensionHelper.bubbleViewHeight + viewDimensionHelper.userInputListHeight - keyboardHeight;


    [self animateLayoutWithDuration:animationDuration animationCurve:animationCurve];
}

- (void)animateLayoutWithDuration:(NSTimeInterval)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve {
    [UIView animateWithDuration:animationDuration delay:0.0 options:[self animationCurveToAnimationOption:animationCurve] animations:^{
        [self.controller.view layoutIfNeeded];
    }                completion:^(BOOL b) {
    }];
}

- (UIViewAnimationOptions)animationCurveToAnimationOption:(UIViewAnimationCurve)curve {
    return (UIViewAnimationOptions) (curve << 16);
}

- (void)hideKeyboard {
    [self.controller hideKeyboard];
}

@end