//
// Created by Jorg on 20/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsumeResult.h"
#import "ConversationAction.h"


@interface TokenConsumed : NSObject <ConsumeResult>
@property(nonatomic, readonly) id<ConversationAction> action;

+ (instancetype)create:(id <ConversationAction>)result;

- (id)initWithResult:(id <ConversationAction>)result;
@end