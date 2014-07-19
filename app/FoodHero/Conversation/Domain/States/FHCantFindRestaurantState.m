//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHCantFindRestaurantState.h"
#import "FHCantAccessLocationServiceState.h"
#import "FHNoRestaurantFoundState.h"
#import "Alternation.h"
#import "RepeatOnce.h"
#import "Concatenation.h"
#import "UDidResolveProblemWithAccessLocationServiceState.h"


@implementation FHCantFindRestaurantState {
    Alternation *_alternation;
}

- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    self = [super init];
    if (self) {

        _alternation = [Alternation create:
                [RepeatOnce create:[Concatenation create:
                                [RepeatOnce create:[FHCantAccessLocationServiceState new]],
                                [RepeatOnce create:[UDidResolveProblemWithAccessLocationServiceState createWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch]], nil]],
                [RepeatOnce create:[FHNoRestaurantFoundState new]], nil];
    }

    return self;
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    return [[FHCantFindRestaurantState alloc] initWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch];
}


- (id <ConversationAction>)consume:(ConversationToken *)token {
    return [_alternation consume:token];
}
@end