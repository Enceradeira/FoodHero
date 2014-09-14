//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHNoRestaurantFoundState.h"
#import "FHNoRestaurantsFound.h"


@implementation FHNoRestaurantFoundState {
}

- (id)init {
    return [super initWithToken:FHNoRestaurantsFound.class];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}

@end