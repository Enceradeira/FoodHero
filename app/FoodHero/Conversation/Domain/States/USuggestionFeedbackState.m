//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SearchAction.h"
#import "SearchActionState.h"
#import "USuggestionFeedbackState.h"
#import "USuggestionNegativeFeedback.h"
#import "UCuisinePreference.h"


@implementation USuggestionFeedbackState{

    id <ConversationSource> _conversationSource;
}
- (id)init {
    self = [super initWithToken:[USuggestionFeedback class]];
    return self;
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    USuggestionFeedback *feedbackToken = (USuggestionFeedback *)token;

    return [feedbackToken createAction: _conversationSource];
}

- (instancetype)initWithActionFeedback:(id <ConversationSource>)conversationSource tokenclass:(Class)tokenclass {
    self = [super initWithToken:tokenclass];
    if( self != nil){
        _conversationSource = conversationSource;
    }
    return self;
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback {
    return [[USuggestionFeedbackState alloc] initWithActionFeedback:actionFeedback tokenclass:USuggestionFeedback.class];
}

@end