//
// Created by Jorg on 29/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHWarningIfNotInPreferredRangeState.h"
#import "Alternation.h"
#import "RepeatOnce.h"
#import "FHWarningIfNotInPreferredRangeTooCheapState.h"


@implementation FHWarningIfNotInPreferredRangeState {
    Alternation *_alternation;
}


- (id)init {
    self = [super init];
    if (self) {
        _alternation = [Alternation create:
                [RepeatOnce create:[FHWarningIfNotInPreferredRangeTooCheapState new]], nil];
    }

    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_alternation consume:token];
}
@end