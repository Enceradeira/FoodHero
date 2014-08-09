//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationViewController.h"
#import "ConversationViewState.h"


@protocol UserInputViewController
- (void)setParentController:(ConversationViewController*)controller;

- (ConversationViewState *)getViewStateForListAnimationCurve:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration;

- (ConversationViewState *)getViewStateForTextInputHeight:(CGFloat)height animationCurve:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration;

- (ConversationToken *)createUserInput;
@end