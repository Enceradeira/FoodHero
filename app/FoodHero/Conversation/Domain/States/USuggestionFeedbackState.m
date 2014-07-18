//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackState.h"
#import "USuggestionFeedback.h"
#import "SearchAction.h"
#import "RestaurantSearch.h"


@implementation USuggestionFeedbackState {

    RestaurantSearch *_restaurantSearch;
    id <ActionFeedbackTarget> _actionFeedback;
}
- (id)init {
    self = [super initWithToken:[USuggestionFeedback class]];
    return self;
}

- (instancetype)initWithActionFeedback:(id <ActionFeedbackTarget>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    self = [self initWithToken:USuggestionFeedback.class];
    if (self != nil) {
        _restaurantSearch = restaurantSearch;
        _actionFeedback = actionFeedback;
    }
    return self;
}

+ (instancetype)createWithActionFeedback:(id <ActionFeedbackTarget>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    return [[USuggestionFeedbackState alloc] initWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch];
}


- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [SearchAction create:_actionFeedback restaurantSearch:_restaurantSearch];
}


@end