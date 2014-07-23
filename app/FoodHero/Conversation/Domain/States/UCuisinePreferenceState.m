//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreferenceState.h"
#import "SearchAction.h"
#import "UCuisinePreference.h"


@implementation UCuisinePreferenceState {
    id <ConversationSource> _actionFeedback;
}

- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback {
    self = [self initWithToken:UCuisinePreference.class];
    if (self != nil) {
        _actionFeedback = actionFeedback;
    }
    return self;
}

+ (UCuisinePreferenceState *)createWithActionFeedback:(id <ConversationSource>)actionFeedback {
    return [[UCuisinePreferenceState alloc] initWithActionFeedback:actionFeedback];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [SearchAction create:_actionFeedback];
}

@end