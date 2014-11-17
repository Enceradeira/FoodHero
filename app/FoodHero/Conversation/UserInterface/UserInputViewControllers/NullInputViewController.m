//
// Created by Jorg on 17/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "NullInputViewController.h"
#import "ConversationViewStateListOrTextInput.h"
#import "ConversationViewStateTextInput.h"


@implementation NullInputViewController {

    ConversationViewController *_parentController;
    ConversationAppService *_appService;
}

- (void)setConversationAppService:(ConversationAppService *)service {
    _appService = service;
}

- (void)setParentController:(ConversationViewController *)controller {
    _parentController = controller;
}

- (void)notifyUserWantsListInput:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    // [_parentController setViewState:[ConversationViewStateListOrTextInput create:_parentController animationDuration:animationDuration animationCurve:animationCurve]];
}

- (void)notifyUserWantsTextInput:(CGFloat)height animationCurve:(UIViewAnimationCurve)curve animationDuration:(double)duration {
    [_parentController setViewState:[ConversationViewStateTextInput create:_parentController heigth:height animationCurve:curve animationDuration:duration]];
}

- (void)sendUserInput {
    NSString *text = _parentController.userTextField.text;
    [_appService addUserCuisinePreference:text];
}


- (NSInteger)optimalViewHeight {
    return 0;
}

@end