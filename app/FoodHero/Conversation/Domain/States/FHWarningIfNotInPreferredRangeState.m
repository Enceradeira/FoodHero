//
// Created by Jorg on 29/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHWarningIfNotInPreferredRangeState.h"
#import "Alternation.h"
#import "RepeatOnce.h"
#import "FHWarningIfNotInPreferredRangeTooCheapState.h"
#import "FHWarningIfNotInPreferredRangeTooExpensiveState.h"
#import "FHWarningIfNotInPreferredRangeTooFarAwayState.h"


@implementation FHWarningIfNotInPreferredRangeState {
    Alternation *_alternation;
}


- (id)init {
    self = [super init];
    if (self) {
        _alternation = [Alternation create:
                [RepeatOnce create:[FHWarningIfNotInPreferredRangeTooCheapState new]],
                [RepeatOnce create:[FHWarningIfNotInPreferredRangeTooExpensiveState new]],
                [RepeatOnce create:[FHWarningIfNotInPreferredRangeTooFarAwayState new]], nil];
    }

    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_alternation consume:token];
}
@end