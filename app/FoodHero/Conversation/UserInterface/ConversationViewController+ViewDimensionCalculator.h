//
// Created by Jorg on 10/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationViewController.h"

@interface ConversationViewController (ViewDimensionCalculator)
- (int)userInputHeaderHeight;

- (int)userInputListHeight;

- (int)bubbleViewHeight;
@end