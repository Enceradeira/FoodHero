//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewState.h"
#import "ConversationViewState+Protected.h"
#import "FoodHeroColors.h"

@implementation ConversationViewState

- (instancetype)initWithController:(ConversationViewController *)controller {
    self = [super init];
    if (self != nil) {
        _controller = controller;
    }
    return self;
}

- (void)activate {
    UITextField *userCuisinePreferenceText = self.controller.userTextField;
    userCuisinePreferenceText.enabled = self.isTextInputEnabled;
    userCuisinePreferenceText.backgroundColor = self.isTextInputEnabled ? nil : [FoodHeroColors lightestBackgroundGrey];

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