//
// Created by Jorg on 07/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "CheatTextFieldController.h"
#import "ConversationAppService.h"


@implementation CheatTextFieldController {

    UIView *_view;
    ConversationAppService *_appService;
}
+ (instancetype)createWithView:(UIView *)view applicationService:(ConversationAppService *)applicationService {
    return [[CheatTextFieldController alloc] initWithView:view applicationService:applicationService];
}

- (id)initWithView:(UIView *)view applicationService:(ConversationAppService *)applicationService {
    self = [super init];
    if (self != nil) {
        _view = view;
        _appService = applicationService;

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 50, 20)];
        textField.backgroundColor = [UIColor redColor];
        textField.delegate = self;
        textField.accessibilityIdentifier = @"cheat text";

        [_view addSubview:textField];
        [_view bringSubviewToFront:textField];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_appService processCheat:textField.text];
    textField.text = @"";
    [textField resignFirstResponder];
    return NO;
}

@end