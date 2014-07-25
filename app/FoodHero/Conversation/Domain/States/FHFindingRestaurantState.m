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
#import "FHProposalState.h"


@implementation FHFindingRestaurantState {
    Concatenation *_concatenation;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _concatenation = [Concatenation create:
                [RepeatAlways create:^(){
                    return [FHCantFindRestaurantState new];
                }],
                [RepeatOnce create:[FHFirstProposalState new]],
                [RepeatAlways create:^(){
                    return [Concatenation create:
                            [RepeatAlways create:^(){
                                return [FHCantFindRestaurantState new];
                            }],
                            [RepeatOnce create:[FHProposalState new]], nil];
                }],
                nil];
    }
    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_concatenation consume:token];
}

@end