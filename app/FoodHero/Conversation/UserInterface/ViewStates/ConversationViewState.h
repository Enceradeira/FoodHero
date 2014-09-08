//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationViewController.h"


@interface ConversationViewState : NSObject
- (instancetype)initWithController:(ConversationViewController *)controller;

- (void)update;

@property(nonatomic, readonly, weak) ConversationViewController *controller;

- (void)activate;
@end