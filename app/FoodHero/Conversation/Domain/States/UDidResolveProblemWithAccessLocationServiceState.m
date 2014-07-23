//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UDidResolveProblemWithAccessLocationServiceState.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "SearchAction.h"
#import "RestaurantSearch.h"


@implementation UDidResolveProblemWithAccessLocationServiceState {
    id <ConversationSource> _actionFeedback;
}

- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback {
    self = [self initWithToken:UDidResolveProblemWithAccessLocationService.class];
    if (self != nil) {
        _actionFeedback = actionFeedback;
    }
    return self;
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback {
    return [[UDidResolveProblemWithAccessLocationServiceState alloc] initWithActionFeedback:actionFeedback];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [SearchAction create:_actionFeedback];
}

@end