//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHProposalState.h"
#import "Concatenation.h"
#import "RepeatOnce.h"
#import "FHSuggestionState.h"
#import "USuggestionFeedbackState.h"
#import "Alternation.h"
#import "FHSuggestionOrSuggestionFollowUpState.h"
#import "FHCommentState.h"
#import "DoOptionally.h"
#import "FHSuggestionWithCommentState.h"
#import "FHConfirmationState.h"
#import "FHWarningIfNotInPreferredRangeState.h"
#import "FHSuggestionAfterWarningState.h"


@implementation FHProposalState {

    Concatenation *_concatenation;
}
- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _concatenation = [Concatenation create:
                [RepeatOnce create:
                        [Alternation create:
                                [RepeatOnce create:
                                        [Concatenation create:
                                                [RepeatOnce create:[FHSuggestionOrSuggestionFollowUpState new]],
                                                [DoOptionally create:[FHCommentState new]], nil]],
                                [RepeatOnce create:
                                        [Concatenation create:
                                                [RepeatOnce create:[FHSuggestionWithCommentState new]],
                                                [RepeatOnce create:[FHConfirmationState new]], nil]],
                                [RepeatOnce create:
                                        [Concatenation create:
                                                [RepeatOnce create:[FHWarningIfNotInPreferredRangeState new]],
                                                [RepeatOnce create:[FHSuggestionAfterWarningState new]], nil]], nil]],


                [RepeatOnce create:[USuggestionFeedbackState new]], nil];
    }
    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_concatenation consume:token];
}

@end
