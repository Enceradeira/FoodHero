//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UWhatToDoNextAnswerState.h"
#import "Alternation.h"
#import "RepeatOnce.h"
#import "UGoodByeState.h"
#import "UWantsToSearchForAnotherRestaurant.h"
#import "UWantsToSearchForAnotherRestaurantState.h"


@implementation UWhatToDoNextAnswerState {

    Alternation *_alternation;
}
- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _alternation = [Alternation create:
                [RepeatOnce create:[UGoodByeState new]],
                [RepeatOnce create:[UWantsToSearchForAnotherRestaurantState new]], nil];
    }

    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_alternation consume:token];
}

@end