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
#import "UCuisinePreference.h"
#import "UCuisinePreferenceState.h"
#import "FHFindingRestaurantState.h"


@implementation FHConversationState {
    NSObject *_currentState;
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
    else if (_currentState.class == [FMOpeningQuestionState class] && token.class == [UCuisinePreference class]) {
        _currentState = [UCuisinePreferenceState createWithActionFeedback:_actionFeedback restaurantSearch:_restaurantSearch];
    }
    else if (_currentState.class == [UCuisinePreferenceState class]) {
        _currentState = [FHFindingRestaurantState new];
    }
    else {
        @throw [DesignByContractException createWithReason:[NSString stringWithFormat:@"invalid state for %@", token.semanticId]];
    }

    id <ConversationAction> action;
    if ([_currentState conformsToProtocol:@protocol(AtomicState)]) {

        action = [(id <AtomicState>) _currentState createAction];
    }
    else {
        action = [(id <CompoundState>) _currentState consume:token];
    }
    if( action == nil){
        @throw [DesignByContractException createWithReason:[NSString stringWithFormat:@"inconclusive action for %@", token.semanticId]];
    }

    return action;
}
@end