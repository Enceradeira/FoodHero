//
// Created by Jorg on 09/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewStateListOnlyInput.h"
#import "ConversationViewState+Protected.h"


@implementation ConversationViewStateListOnlyInput {

}

+ (instancetype)create:(ConversationViewController *)controller animationDuration:(NSTimeInterval)animationDuration animationCurve:(enum UIViewAnimationCurve)animationCurve {
    return [[ConversationViewStateListOnlyInput alloc] initWithController:controller animationDuration:animationDuration animationCurve:animationCurve];
}

- (void)activate {
    [super activate];
}

- (BOOL)isTextInputEnabled {
    return NO;
}

- (BOOL)isKeyboardVisible {
    return NO;
}

- (BOOL)isUserInputListButtonEnabled {
    return YES;
}

@end