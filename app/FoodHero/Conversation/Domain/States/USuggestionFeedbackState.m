//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SearchAction.h"
#import "USuggestionFeedbackState.h"
#import "USuggestionNegativeFeedback.h"
#import "UCuisinePreference.h"


@implementation USuggestionFeedbackState {
}

- (id)init {
    self = [super initWithToken:[USuggestionFeedback class]];
    return self;
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    USuggestionFeedback *feedbackToken = (USuggestionFeedback *)token;

    return [feedbackToken createAction];
}
@end