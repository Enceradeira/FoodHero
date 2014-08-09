//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewState.h"
#import "ConversationViewState+Protected.h"

@implementation ConversationViewState

- (instancetype)initWithController:(ConversationViewController *)controller {
    self = [super init];
    if (self != nil) {
        _controller = controller;
    }
    return self;
}

- (void)activate {
    self.controller.userCuisinePreferenceText.enabled = self.isTextInputEnabled;
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