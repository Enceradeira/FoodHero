//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHConversationState.h"
#import "FHGreetingState.h"
#import "FHFindingRestaurantState.h"
#import "Concatenation.h"
#import "RepeatOnce.h"
#import "FHAskCuisinePreferenceState.h"
#import "FHFindingRestaurantFinishedState.h"


@implementation FHConversationState {
    Concatenation *_concatenation;
}

- (instancetype)init{
    self = [super init];
    if (self != nil) {
        _concatenation = [Concatenation create:[RepeatOnce create:[FHGreetingState new]],
                                               [RepeatOnce create:[FHAskCuisinePreferenceState new]],
                                               [RepeatOnce create:[FHFindingRestaurantState new]],
                                               [RepeatOnce create:[FHFindingRestaurantFinishedState new]], nil];
    }
    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_concatenation consume:token];
}

@end