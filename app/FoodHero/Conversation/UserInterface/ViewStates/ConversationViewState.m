//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewState.h"
#import "ConversationViewState+Protected.h"
#import "FoodHeroColors.h"
#import "ConversationViewStateListOrTextInput.h"

@implementation ConversationViewState

- (instancetype)initWithController:(ConversationViewController *)controller {
    self = [super init];
    if (self != nil) {
        _controller = controller;
    }
    return self;
}

- (void)update {

    // text input
    UITextField *userTextField = self.controller.userTextField;
    userTextField.enabled = self.isTextInputEnabled && _controller.isUserInputEnabled;
    userTextField.backgroundColor = userTextField.enabled ? nil : [FoodHeroColors lightestBackgroundGrey];

    // send-button
    NSString *text = userTextField.text;
    _controller.userSendButton.enabled =
            text.length > 0
                    && _controller.isUserInputEnabled;

    // list-button
    self.controller.userInputListButton.enabled =
            self.isUserInputListButtonEnabled
            && _controller.isUserInputEnabled;
}

- (void)activate {
    [self update];

    if (!self.isKeyboardVisible) {
        [self hideKeyboard];
    }
}

- (BOOL)isEqual:(id)other {
    return [[other class] isEqual:[self class]];
}

- (void)hideKeyboard {
    [self.controller hideKeyboard];
}

@end