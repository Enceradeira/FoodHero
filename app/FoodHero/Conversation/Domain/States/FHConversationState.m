//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHConversationState.h"
#import "FHGreeting.h"
#import "FMGreetingState.h"
#import "FMOpeningQuestionState.h"
#import "DesignByContractException.h"


@implementation FHConversationState {
    ConversationState *_currentState;
}
- (ConversationAction *)consume:(ConversationToken *)token {
    if (_currentState == nil && token.class == FHGreeting.class) {
        _currentState = [FMGreetingState new];
    }
    else if (_currentState.class == [FMGreetingState class]) {
        _currentState = [FMOpeningQuestionState new];
    }
    else {
        @throw [DesignByContractException createWithReason:@"invalid state"];
    }

    return [_currentState createAction];
}
@end