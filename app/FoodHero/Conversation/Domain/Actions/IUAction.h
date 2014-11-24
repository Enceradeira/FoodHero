//
// Created by Jorg on 17/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationAction.h"

@protocol IUAction <ConversationAction>
- (NSString *)getStateName;
@end