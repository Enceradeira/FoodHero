//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionWithConfirmationIfInNewPreferredRangeMoreExpensiveState.h"
#import "FHSuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive.h"
#import "AskUserSuggestionFeedbackAction.h"


@implementation FHSuggestionWithConfirmationIfInNewPreferredRangeMoreExpensiveState {
}


- (instancetype)init {
    return (FHSuggestionWithConfirmationIfInNewPreferredRangeMoreExpensiveState *) [super initWithToken:[FHSuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive class]];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}

@end