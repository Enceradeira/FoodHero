//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionState.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "FHSuggestion.h"


@implementation FHSuggestionState {

}

- (id)init {
    return [super initWithToken:FHSuggestion.class];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}

@end