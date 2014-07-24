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


@implementation FHProposalState {

    Concatenation *_concatenation;
}
- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback {
    self = [super init];
    if (self != nil) {
        _concatenation = [Concatenation create:
                [RepeatOnce create:
                        [Alternation create:
                                [RepeatOnce create:
                                        [Concatenation create:
                                                [RepeatOnce create:[FHSuggestionOrSuggestionFollowUpState new]],
                                                [DoOptionally create:[FHCommentState new]], nil]]]],
                [RepeatOnce create:[USuggestionFeedbackState createWithActionFeedback:actionFeedback]], nil];
    }
    return self;
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback {
    return [[FHProposalState alloc] initWithActionFeedback:actionFeedback];
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_concatenation consume:token];
}

- (BOOL)isInState:(Class)state {
    if (self.class == state) {
        return YES;
    }
    return [_concatenation isInState:state];
}

@end
