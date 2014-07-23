//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHConversationState.h"
#import "FMGreetingState.h"
#import "UCuisinePreferenceState.h"
#import "FHFindingRestaurantState.h"
#import "Concatenation.h"
#import "DesignByContractException.h"
#import "RepeatOnce.h"
#import "FHAskCuisinePreferenceState.h"


@implementation FHConversationState {
    Concatenation *_concatenation;
}

- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    self = [super init];
    if (self != nil) {
        _concatenation = [Concatenation create:[RepeatOnce create:[FMGreetingState new]],
                                               [RepeatOnce create:[FHAskCuisinePreferenceState createWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch]],
                                               [RepeatOnce create:[FHFindingRestaurantState createWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch]], nil];
    }
    return self;
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    return [[FHConversationState alloc] initWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch];
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