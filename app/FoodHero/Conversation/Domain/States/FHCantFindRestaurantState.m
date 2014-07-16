//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHCantFindRestaurantState.h"
#import "FHCantAccessLocationServiceState.h"


@implementation FHCantFindRestaurantState {

}
- (id <ConversationAction>)consume:(ConversationToken *)token {
    return [[FHCantAccessLocationServiceState new] consume:token];
}
@end