//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHConversationState.h"
#import "FHGreeting.h"
#import "FMGreetingState.h"
#import "FMOpeningQuestionState.h"
#import "DesignByContractException.h"
#import "FHOpeningQuestion.h"
#import "UserCuisinePreference.h"
#import "UCuisinePreferenceState.h"
#import "FHFindingRestaurantState.h"


@implementation FHConversationState {
    ConversationState *_currentState;
    RestaurantSearch *_restaurantSearch;
    id <ActionFeedbackTarget> _actionFeedback;
}

- (instancetype)initWithActionFeedback:(id <ActionFeedbackTarget>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    self = [super self];
    if (self != nil) {
        _restaurantSearch = restaurantSearch;
        _actionFeedback = actionFeedback;
    }
    return self;
}

+ (instancetype)createWithActionFeedback:(id <ActionFeedbackTarget>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    return [[FHConversationState alloc] initWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch];
}

- (id <ConversationAction>)consume:(ConversationToken *)token {
    if (_currentState == nil && token.class == FHGreeting.class) {
        _currentState = [FMGreetingState new];
    }
    else if (_currentState.class == [FMGreetingState class] && token.class == [FHOpeningQuestion class]) {
        _currentState = [FMOpeningQuestionState new];
    }
    else if (_currentState.class == [FMOpeningQuestionState class] && token.class == [UserCuisinePreference class]) {
        _currentState = [UCuisinePreferenceState createWithActionFeedback:_actionFeedback restaurantSearch:_restaurantSearch];
    }
    else if (_currentState.class == [UCuisinePreferenceState class]){
        FHFindingRestaurantState *state = [FHFindingRestaurantState new];
        _currentState = state;
        return [state consume:token];
    }
    else {
        @throw [DesignByContractException createWithReason:[NSString stringWithFormat:@"invalid state for %@", token.semanticId]];
    }

    return [_currentState createAction];
}
@end