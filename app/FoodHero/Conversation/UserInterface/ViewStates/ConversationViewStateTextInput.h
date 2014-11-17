//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationViewState.h"


@interface ConversationViewStateTextInput : ConversationViewState
+ (instancetype)create:(ConversationViewController *)controller heigth:(CGFloat)heigth animationCurve:(UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration;
@end