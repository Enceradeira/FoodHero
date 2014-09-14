//
// Created by Jorg on 29/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionAfterWarningState.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "FHSuggestionAfterWarning.h"


@implementation FHSuggestionAfterWarningState {

}
- (instancetype)init {
    self = [super initWithToken:[FHSuggestionAfterWarning class]];
    return self;
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}

@end