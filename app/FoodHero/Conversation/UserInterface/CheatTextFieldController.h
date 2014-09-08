//
// Created by Jorg on 07/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConversationAppService;


@interface CheatTextFieldController : NSObject <UITextFieldDelegate>
+ (instancetype)createWithView:(UIView *)view applicationService:(ConversationAppService *)service;

- (id)initWithView:(UIView *)view applicationService:(ConversationAppService *)service;
@end