//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionState.h"
#import "AskUserSuggestionFeedbackAction.h"


@implementation FHSuggestionState {

}

- (id<ConversationAction>)createAction {
    return [AskUserSuggestionFeedbackAction new];
}

@end