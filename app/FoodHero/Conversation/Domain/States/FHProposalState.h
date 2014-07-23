//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"
#import "ConversationSource.h"
#import "RestaurantSearch.h"


@interface FHProposalState : NSObject <Symbol>
+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback;
@end