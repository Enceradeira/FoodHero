//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UTryAgainNowState.h"
#import "SearchAction.h"
#import "RestaurantSearch.h"
#import "UTryAgainNow.h"

@implementation UTryAgainNowState {

    RestaurantSearch *_restaurantSearch;
    id <ConversationSource> _actionFeedback;
}

- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    self = [self initWithToken:UTryAgainNow.class];
    if (self != nil) {
        _restaurantSearch = restaurantSearch;
        _actionFeedback = actionFeedback;
    }
    return self;
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    return [[UTryAgainNowState alloc] initWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch];
}


- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [SearchAction create:_actionFeedback restaurantSearch:_restaurantSearch];
}
@end