//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHFindingRestaurantState.h"
#import "FHFirstProposalState.h"
#import "FHCantFindRestaurantState.h"
#import "RepeatOnce.h"
#import "Concatenation.h"
#import "RepeatAlways.h"


@implementation FHFindingRestaurantState {
    Concatenation *_concatenation;
}

- (id)init {
    self = [super init];
    if (self) {
        _concatenation = [Concatenation create:
                [RepeatAlways create:^(){
                    return [FHCantFindRestaurantState new];
                }],
                [RepeatOnce create:[FHFirstProposalState new]], nil];
    }

    return self;
}

- (id <ConversationAction>)consume:(ConversationToken *)token {
    return [_concatenation consume:token];
}
@end