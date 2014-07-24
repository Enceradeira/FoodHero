//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHCommentState.h"
#import "Alternation.h"
#import "RepeatOnce.h"
#import "FHSuggestionState.h"
#import "FHSuggestionAsFollowUpState.h"
#import "FHConfirmationIfInNewPreferredRangeState.h"


@implementation FHCommentState {

    Alternation *_alternation;
}


- (id)init {
    self = [super init];
    if (self) {
        _alternation = [Alternation create:
                [RepeatOnce create:[FHConfirmationIfInNewPreferredRangeState new]], nil];
    }

    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_alternation consume:token];
}

@end