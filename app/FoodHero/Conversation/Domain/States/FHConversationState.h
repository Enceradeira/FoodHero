//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationAction.h"
#import "ConversationToken.h"
#import "ConversationSource.h"
#import "Symbol.h"

@class RestaurantSearch;

@interface FHConversationState : NSObject <Symbol>
- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback;

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback;
@end