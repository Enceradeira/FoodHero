//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationAction.h"
#import "ConversationToken.h"
#import "ConsumeResult.h"

@protocol Symbol
- (id <ConsumeResult>)consume:(ConversationToken *)token;
@end