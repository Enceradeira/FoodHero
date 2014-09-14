//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"

@class TextRepository;

@interface ConversationToken (Protected)
+ (TextRepository *)textRepository;
- (TextRepository *)textRepository;
@end