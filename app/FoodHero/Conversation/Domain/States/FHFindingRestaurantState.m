//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHFindingRestaurantState.h"
#import "FHFirstProposalState.h"
#import "FHCantFindRestaurantState.h"


@implementation FHFindingRestaurantState {
}
- (ConversationAction *)consume:(ConversationToken *)token {
    ConversationAction *action = [[FHCantFindRestaurantState new] consume:token];
    if (action != nil) {
        return action;
    }

    return [[FHFirstProposalState new] consume:token];
}
@end