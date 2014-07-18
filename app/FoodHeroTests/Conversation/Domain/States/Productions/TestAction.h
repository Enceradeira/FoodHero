//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationAction.h"
#import "Symbol.h"



@interface TestAction : NSObject<ConversationAction>
@property (nonatomic, readonly) id<Symbol> sender;

+ (instancetype)create:(id <Symbol>)sender;
@end