//
// Created by Jorg on 17/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInputViewController.h"


@interface NullInputViewController : UIViewController <UserInputViewController>
- (void)setConversationAppService:(ConversationAppService *)service;

- (void)setInputHandler:(SEL)inputHandler;
@end