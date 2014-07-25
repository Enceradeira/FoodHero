//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCloserState.h"
#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCloser.h"
#import "AskUserSuggestionFeedbackAction.h"


@implementation FHSuggestionWithConfirmationIfInNewPreferredRangeCloserState {
}


- (instancetype)init {
    return (FHSuggestionWithConfirmationIfInNewPreferredRangeCloserState *) [super initWithToken:[FHSuggestionWithConfirmationIfInNewPreferredRangeCloser class]];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [AskUserSuggestionFeedbackAction new];
}


@end