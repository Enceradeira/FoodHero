//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHConfirmationIfInNewPreferredRangeState.h"
#import "Alternation.h"
#import "RepeatOnce.h"
#import "FHSuggestionState.h"
#import "FHConfirmationIfInNewPreferredRangeCheaperState.h"
#import "FHConfirmationIfInNewPreferredRangeCloserState.h"
#import "FHConfirmationIfInNewPreferredRangeMoreExpensiveState.h"


@implementation FHConfirmationIfInNewPreferredRangeState {

    Alternation *_alternation;
}


- (id)init {
    self = [super init];
    if (self) {
        _alternation = [Alternation create:
                [RepeatOnce create:[FHConfirmationIfInNewPreferredRangeCheaperState create]],
                [RepeatOnce create:[FHConfirmationIfInNewPreferredRangeCloserState create]],
                [RepeatOnce create:[FHConfirmationIfInNewPreferredRangeMoreExpensiveState create]], nil];
    }

    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_alternation consume:token];
}

@end