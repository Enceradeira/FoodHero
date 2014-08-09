//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewStateTextInput.h"
#import "ConversationViewController.h"
#import "ConversationViewState+Protected.h"


@implementation ConversationViewStateTextInput {

    CGFloat _keyboardHeight;
    double _animationDuration;
    UIViewAnimationCurve _animationCurve;
}

- (instancetype)initWithController:(ConversationViewController *)controller keyboardHeight:(CGFloat)keyboardHeight animationCurve:(UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    self = [super initWithController:controller];
    if (self != nil) {
        _keyboardHeight = keyboardHeight;
        _animationDuration = animationDuration;
        _animationCurve = animationCurve;
    }
    return self;
}

+ (instancetype)create:(ConversationViewController *)controller heigth:(CGFloat)heigth animationCurve:(UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    return [[ConversationViewStateTextInput alloc] initWithController:controller keyboardHeight:heigth animationCurve:animationCurve animationDuration:animationDuration];
}

- (void)activate {
    [super activate];
    [super adjustViewsForKeyboardHeight:_keyboardHeight animationDuration:_animationDuration animationCurve:_animationCurve];
}


@end