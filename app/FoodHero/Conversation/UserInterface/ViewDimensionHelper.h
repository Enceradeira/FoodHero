//
// Created by Jorg on 06/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@class ConversationViewController;

@interface ViewDimensionHelper : NSObject
- (int)userInputHeaderHeight;

- (int)userInputListHeight;

- (int)bubbleViewHeight;

+ (instancetype)create:(ConversationViewController *)controller;
@end
