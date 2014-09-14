//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionAsFollowUpState.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "FHSuggestion.h"
#import "FHSuggestionAsFollowUp.h"


@implementation FHSuggestionAsFollowUpState {

}

- (instancetype)init {
    self = [super initWithToken:[FHSuggestionAsFollowUp class]];
    return self;
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}


@end