//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInputViewSubscriber.h"
#import "ConversationViewController.h"
#import "ConversationViewState.h"


@protocol UserInputViewController
- (void)setDelegate:(id <UserInputViewSubscriber>)delegate;

- (ConversationViewState *)getViewStateForList:(ConversationViewController *)mainController animationCurve:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration;

- (ConversationViewState *)getViewStateForTextInput:(ConversationViewController *)controller height:(CGFloat)height animationCurve:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration;

- (ConversationToken *)createUserInput:(ConversationViewController *)controller;
@end