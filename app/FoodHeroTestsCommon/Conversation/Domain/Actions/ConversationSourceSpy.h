//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationSource.h"


@interface ConversationSourceSpy : NSObject <ConversationSource>
@property(nonatomic, readonly) NSMutableArray *tokens;
@end