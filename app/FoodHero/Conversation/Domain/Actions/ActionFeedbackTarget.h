//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"

@protocol ActionFeedbackTarget <NSObject>
- (void)addToken:(ConversationToken *)token;
@end