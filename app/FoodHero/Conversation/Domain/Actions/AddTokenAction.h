//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationAction.h"
#import "ConversationSource.h"
#import "RestaurantSearch.h"
#import "FHAction.h"

@class FHWhatToDoNext;


@interface AddTokenAction : NSObject <FHAction>
+ (instancetype)create:(ConversationToken *)token;
@end