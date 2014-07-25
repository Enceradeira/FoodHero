//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHFindingRestaurantFinishedState.h"
#import "Concatenation.h"
#import "FHWhatToDoNextState.h"
#import "RepeatOnce.h"


@implementation FHFindingRestaurantFinishedState {

    Concatenation *_concatenation;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _concatenation = [Concatenation create:[RepeatOnce create:[FHWhatToDoNextState new]], nil];
    }

    return self;
}


- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_concatenation consume:token];
}

@end