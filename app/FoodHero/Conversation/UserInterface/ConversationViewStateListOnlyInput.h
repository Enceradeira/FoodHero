//
// Created by Jorg on 09/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationViewStateListOrTextInput.h"


@interface ConversationViewStateListOnlyInput : ConversationViewStateListOrTextInput
+ (instancetype)create:(ConversationViewController *)controller animationDuration:(NSTimeInterval)animationDuration animationCurve:(enum UIViewAnimationCurve)animationCurve;
@end