//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreferenceState.h"
#import "SearchAction.h"
#import "UCuisinePreference.h"


@implementation UCuisinePreferenceState {
    RestaurantSearch *_restaurantSearch;
    id <ConversationSource> _actionFeedback;
}

- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    self = [self initWithToken:UCuisinePreference.class];
    if (self != nil) {
        _restaurantSearch = restaurantSearch;
        _actionFeedback = actionFeedback;
    }
    return self;
}

+ (UCuisinePreferenceState *)createWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    return [[UCuisinePreferenceState alloc] initWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [SearchAction create:_actionFeedback restaurantSearch:_restaurantSearch];
}

@end