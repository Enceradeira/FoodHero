//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHAskCuisinePreferenceState.h"
#import "Concatenation.h"
#import "RepeatOnce.h"
#import "FMOpeningQuestionState.h"
#import "UCuisinePreferenceState.h"
#import "ActionFeedbackTarget.h"


@implementation FHAskCuisinePreferenceState {

    Concatenation *_concatenation;
}
- (instancetype)initWithActionFeedback:(id <ActionFeedbackTarget>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    self = [super init];
    if (self) {
        _concatenation = [Concatenation create:
                [RepeatOnce create:[FMOpeningQuestionState new]],
                [RepeatOnce create:[UCuisinePreferenceState createWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch]], nil];
    }

    return self;
}

+ (instancetype)createWithActionFeedback:(id <ActionFeedbackTarget>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    return [[FHAskCuisinePreferenceState alloc] initWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch];
}

- (id <ConversationAction>)consume:(ConversationToken *)token {
    return [_concatenation consume:token];
}

@end