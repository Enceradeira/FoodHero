//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHCantFindRestaurantState.h"
#import "FHCantAccessLocationServiceState.h"
#import "FHNoRestaurantFoundState.h"
#import "FHNoRestaurantsFound.h"


@implementation FHCantFindRestaurantState {

}
- (id <ConversationAction>)consume:(ConversationToken *)token {
    id <ConversationAction> action = [[FHCantAccessLocationServiceState new] consume:token];
    if( action != nil)
    {
        return action;
    }
    if( token.class == [FHNoRestaurantsFound class]){
        return [[FHNoRestaurantFoundState new]createAction];
    }
    return nil;
}
@end