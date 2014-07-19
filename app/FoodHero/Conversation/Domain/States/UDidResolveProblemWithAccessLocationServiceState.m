//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UDidResolveProblemWithAccessLocationServiceState.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "SearchAction.h"
#import "RestaurantSearch.h"


@implementation UDidResolveProblemWithAccessLocationServiceState {
    RestaurantSearch *_restaurantSearch;
    id <ConversationSource> _actionFeedback;
}

- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    self = [self initWithToken:UDidResolveProblemWithAccessLocationService.class];
    if (self != nil) {
        _restaurantSearch = restaurantSearch;
        _actionFeedback = actionFeedback;
    }
    return self;
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    return [[UDidResolveProblemWithAccessLocationServiceState alloc] initWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [SearchAction create:_actionFeedback restaurantSearch:_restaurantSearch];
}

@end