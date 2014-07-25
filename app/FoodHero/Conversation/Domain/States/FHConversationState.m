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
#import "RepeatAlways.h"
#import "DesignByContractException.h"


@implementation FHConversationState {
    Concatenation *_concatenation;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {

        _concatenation = [Concatenation create:
                [RepeatOnce create:[FHGreetingState new]],
                [RepeatAlways create:^(){
                    return
                            [Concatenation create:
                                    [RepeatOnce create:
                                            [FHAskCuisinePreferenceState new]],
                                    [RepeatOnce create:
                                            [FHFindingRestaurantState new]],
                                    [RepeatOnce create:
                                            [FHFindingRestaurantFinishedState new]], nil];
                }], nil];
    }
    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    id <ConsumeResult> result = [_concatenation consume:token];
    if (result.isStateFinished) {
        @throw [DesignByContractException createWithReason:@"Conversation has finised. This indicates an invalid state"];
    }
    return result;
}

@end