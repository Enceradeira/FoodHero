//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHCantFindRestaurantState.h"
#import "FHCantAccessLocationServiceState.h"
#import "FHNoRestaurantFoundState.h"
#import "Alternation.h"
#import "RepeatOnce.h"


@implementation FHCantFindRestaurantState {
    Alternation *_alternation;
}

- (id)init {
    self = [super init];
    if (self) {
        _alternation = [Alternation create:
                [RepeatOnce create:[FHCantAccessLocationServiceState new]],
                [RepeatOnce create:[FHNoRestaurantFoundState new]], nil];
    }

    return self;
}

- (id <ConversationAction>)consume:(ConversationToken *)token {
    return [_alternation consume:token];
}
@end