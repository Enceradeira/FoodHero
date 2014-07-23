//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "Symbol.h"
#import "ConversationSource.h"
#import "RestaurantSearch.h"

@interface FHFindingRestaurantState : NSObject <Symbol>
+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback;
@end