//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationAction.h"
#import "ConversationToken.h"
#import "ConversationState.h"

@interface FHConversationState : ConversationState
- (ConversationAction *)consume:(ConversationToken *)token;
@end