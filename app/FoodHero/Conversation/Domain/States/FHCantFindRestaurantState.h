//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConversationAction.h"
#import "ConversationToken.h"

@interface FHCantFindRestaurantState : NSObject
- (id <ConversationAction>)consume:(ConversationToken *)token;
@end