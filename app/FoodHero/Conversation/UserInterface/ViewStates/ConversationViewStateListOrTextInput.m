//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewStateListOrTextInput.h"
#import "ConversationViewState+Protected.h"
#import "ConversationViewController+ViewDimensionCalculator.h"

@implementation ConversationViewStateListOrTextInput {

    ConversationViewController *_controller;
    NSTimeInterval _animationDuration;
    UIViewAnimationCurve _animationCurve;
}

- (instancetype)initWithController:(ConversationViewController *)controller animationDuration:(NSTimeInterval)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve {
    self = [super initWithController:controller];
    if (self != nil) {
        _controller = controller;
        _animationDuration = animationDuration;
        _animationCurve = animationCurve;
    }
    return self;
}

+ (instancetype)create:(ConversationViewController *)controller animationDuration:(NSTimeInterval)animationDuration animationCurve:(enum UIViewAnimationCurve)animationCurve {
    return [[ConversationViewStateListOrTextInput alloc] initWithController:controller animationDuration:animationDuration animationCurve:animationCurve];
}

- (void)activate {
    [super activate];

    _controller.userInputHeightConstraint.constant =  self.controller.userInputListHeight;
    _controller.userInputHeaderHeightConstraint.constant = self.controller.userInputHeaderHeight;
    _controller.bubbleViewHeightConstraint.constant = self.controller.bubbleViewHeight;

    [self animateLayoutWithDuration:_animationDuration animationCurve:_animationCurve];

    // moves the last conversation bubble into view
    int section = 0;
    NSInteger nrRows = [_controller.bubbleView numberOfRowsInSection:section];
    [_controller.bubbleView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:nrRows - 1 inSection:section] atScrollPosition:UITableViewScrollPositionNone animated:NO];

}

- (BOOL)isKeyboardVisible {
    return NO;
}

- (BOOL)isTextInputEnabled {
    return YES;
}

- (BOOL)isUserInputListButtonEnabled {
    return NO;
}

@end