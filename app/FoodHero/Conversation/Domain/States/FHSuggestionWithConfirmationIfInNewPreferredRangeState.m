//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionWithConfirmationIfInNewPreferredRangeState.h"
#import "Alternation.h"
#import "RepeatOnce.h"
#import "FHSuggestionState.h"
#import "FHSuggestionAsFollowUpState.h"
#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCheaperState.h"
#import "FHSuggestionWithConfirmationIfInNewPreferredRangeMoreExpensiveState.h"
#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCloserState.h"


@implementation FHSuggestionWithConfirmationIfInNewPreferredRangeState {

    Alternation *_alternation;
}


- (id)init {
    self = [super init];
    if (self) {
        _alternation = [Alternation create:
                [RepeatOnce create:[FHSuggestionWithConfirmationIfInNewPreferredRangeCheaperState new]],
                [RepeatOnce create:[FHSuggestionWithConfirmationIfInNewPreferredRangeMoreExpensiveState new]],
                [RepeatOnce create:[FHSuggestionWithConfirmationIfInNewPreferredRangeCloserState new]], nil];
    }

    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_alternation consume:token];
}

@end