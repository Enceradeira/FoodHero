//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "ConversationAction.h"


@interface ConversationEngine : NSObject

- (ConversationAction *)consume:(ConversationToken *)input;
@end