//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackState.h"
#import "USuggestionFeedback.h"
#import "UCuisinePreference.h"


@implementation USuggestionFeedbackState{

}
- (id)init {
    self = [super initWithToken:[USuggestionFeedback class]];
    return self;
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback {
    return [[USuggestionFeedbackState alloc] initWithActionFeedback:actionFeedback tokenclass:USuggestionFeedback.class];
}


@end