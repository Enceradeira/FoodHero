//
// Created by Jorg on 17/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationAction.h"
#import "UActionVisitor.h"

@protocol UAction <ConversationAction>
- (void)accept:(id <UActionVisitor>)visitor;
@end