//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"


@interface GenericToken : ConversationToken
+ (ConversationToken *)createWithSemanticId:(NSString *)semanticId text:(NSString *)text action:(id <ConversationAction>)action;

- (instancetype)initWithSemanticId:(NSString *)semanticId text:(NSString *)text action:(id <ConversationAction>)action;
@end