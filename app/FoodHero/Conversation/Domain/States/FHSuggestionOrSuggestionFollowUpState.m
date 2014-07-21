//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionOrSuggestionFollowUpState.h"
#import "Alternation.h"
#import "RepeatOnce.h"
#import "FHSuggestionState.h"
#import "FHSuggestionAsFollowUpState.h"
#import "RandomAlternation.h"


@implementation FHSuggestionOrSuggestionFollowUpState {

    RandomAlternation *_alternation;
}


- (id)init {
    self = [super init];
    if (self) {
        _alternation = [RandomAlternation create:
                @"FH:SuggestionState", [RepeatOnce create:[FHSuggestionState new]],
                @"FH:SuggestionAsFollowUp", [RepeatOnce create:[FHSuggestionAsFollowUpState new]], nil];
    }

    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_alternation consume:token];
}

@end