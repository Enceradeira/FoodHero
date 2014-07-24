//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SearchActionState.h"
#import "SearchAction.h"
#import "UCuisinePreference.h"


@implementation SearchActionState {
    id <ConversationSource> _actionFeedback;
}

- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback tokenclass:(Class)tokenclass {
    self = [self initWithToken:tokenclass];
    if (self != nil) {
        _actionFeedback = actionFeedback;
    }
    return self;
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [SearchAction create:_actionFeedback];
}

@end