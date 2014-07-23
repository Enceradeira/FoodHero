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

- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    self = [self init];
    if (self != nil) {
        _concatenation = [Concatenation create:
                [RepeatAlways create:^(){
                    return [FHCantFindRestaurantState createWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch];
                }],
                [RepeatOnce create:[FHFirstProposalState createWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch]],
                [RepeatAlways create:^(){
                    return [Concatenation create:
                            [RepeatAlways create:^(){
                                return [FHCantFindRestaurantState createWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch];
                            }],
                            [RepeatOnce create:[FHProposalState createWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch]], nil];
                }],
                nil];
    }
    return self;
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    return [[FHFindingRestaurantState alloc] initWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch];
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_concatenation consume:token];
}

- (BOOL)isInState:(Class)state {
    if( self.class == state){
        return YES;
    }
    return [_concatenation isInState:state];
}
@end