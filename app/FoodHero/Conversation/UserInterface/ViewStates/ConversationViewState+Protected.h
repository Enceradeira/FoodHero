//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationViewState.h"

@interface ConversationViewState (Protected)

- (void)adjustViewsForKeyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve;

- (void)animateLayoutWithDuration:(NSTimeInterval)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve;

- (BOOL)isTextInputEnabled;

- (BOOL)isKeyboardVisible;

- (BOOL)isUserInputListButtonEnabled;
@end