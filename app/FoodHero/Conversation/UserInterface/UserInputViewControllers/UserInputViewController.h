//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationViewController.h"
#import "ConversationViewState.h"


@protocol UserInputViewController
- (void)setParentController:(ConversationViewController *)controller;

- (void)notifyUserWantsListInput:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)duration;

- (void)notifyUserWantsTextInput:(CGFloat)height animationCurve:(UIViewAnimationCurve)curve animationDuration:(double)duration;

- (void)sendUserInput;

- (int)optimalViewHeight;
@end