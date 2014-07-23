//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackState.h"
#import "USuggestionFeedback.h"
#import "SearchAction.h"
#import "RestaurantSearch.h"


@implementation USuggestionFeedbackState {

    id <ConversationSource> _actionFeedback;
}
- (id)init {
    self = [super initWithToken:[USuggestionFeedback class]];
    return self;
}

- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback {
    self = [self initWithToken:USuggestionFeedback.class];
    if (self != nil) {
        _actionFeedback = actionFeedback;
    }
    return self;
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback {
    return [[USuggestionFeedbackState alloc] initWithActionFeedback:actionFeedback];
}


- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [SearchAction create:_actionFeedback];
}


@end