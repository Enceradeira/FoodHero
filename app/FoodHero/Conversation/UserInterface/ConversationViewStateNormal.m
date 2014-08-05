//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewStateNormal.h"
#import "ConversationViewController.h"


@implementation ConversationViewStateNormal {

    double _animationDuration;
    UIViewAnimationCurve _animationCurve;
}
- (instancetype)initWithController:(ConversationViewController *)controller animationCurve:(UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    self = [super initWithController:controller];
    if (self != nil) {
        _animationDuration = animationDuration;
        _animationCurve = animationCurve;
    }
    return self;
}

+ (instancetype)create:(ConversationViewController *)controller animationCurve:(UIViewAnimationCurve)animationCurve aimationDuration:(double)animationDuration {
    return [[ConversationViewStateNormal alloc] initWithController:controller animationCurve:animationCurve animationDuration:animationDuration];
}

- (void)animateChange {
    [super hideKeyboard];
    [super adjustViewsForKeyboardHeight:0 animationDuration:_animationDuration animationCurve:_animationCurve];
}


@end