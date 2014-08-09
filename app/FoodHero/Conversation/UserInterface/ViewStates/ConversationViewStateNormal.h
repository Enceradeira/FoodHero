//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationViewState.h"

@class ConversationViewController;


@interface ConversationViewStateNormal : ConversationViewState
+ (instancetype)create:(ConversationViewController *)controller animationCurve:(UIViewAnimationCurve)animationCurve aimationDuration:(double)animationDuration;
@end