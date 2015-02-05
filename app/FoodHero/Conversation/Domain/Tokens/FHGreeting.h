//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"

@class TextAndSound;


@interface FHGreeting : ConversationToken
- (instancetype)initWithSemanticIdAndText:(NSString *const)semanticId text:(NSString *)text;

+ (instancetype)create;
@end