//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHFirstProposalState.h"
#import "FHSuggestion.h"
#import "AskUserSuggestionFeedbackAction.h"


@implementation FHFirstProposalState {
}
- (id)init {
    return [super initWithToken:FHSuggestion.class];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [AskUserSuggestionFeedbackAction new];
}
@end