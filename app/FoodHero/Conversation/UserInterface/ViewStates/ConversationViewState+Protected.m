//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewState+Protected.h"
#import "DesignByContractException.h"
#import "ConversationViewController+ViewDimensionCalculator.h"


@implementation ConversationViewState (Protected)

- (void)adjustViewsForKeyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve {

    self.controller.userInputHeightConstraint.constant = 0;
    self.controller.userInputHeaderHeightConstraint.constant = self.controller.userInputHeaderHeight;
    // bubbleView gets the space from the hidden userInputList but is shortened by keyboardHeight
    self.controller.bubbleViewHeightConstraint.constant = self.controller.bubbleViewHeight + self.controller.userInputListHeight - keyboardHeight;

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

- (BOOL)isTextInputEnabled {
    @throw [DesignByContractException createWithReason:@"subclass must override method"];
}

- (BOOL)isKeyboardVisible {
    @throw [DesignByContractException createWithReason:@"subclass must override method"];
}

- (BOOL)isUserInputListButtonEnabled {
    @throw [DesignByContractException createWithReason:@"subclass must override method"];
}

@end