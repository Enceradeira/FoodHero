//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHProposalState.h"
#import "Concatenation.h"
#import "RepeatOnce.h"
#import "FHSuggestionState.h"
#import "USuggestionFeedbackState.h"
#import "Alternation.h"
#import "FHSuggestionOrSuggestionFollowUpState.h"


@implementation FHProposalState {

    Concatenation *_concatenation;
}
- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    self = [super init];
    if (self != nil) {
        _concatenation = [Concatenation create:
                [RepeatOnce create:
                        [Alternation create:
                                [RepeatOnce create:
                                        [Concatenation create:
                                                [RepeatOnce create:[FHSuggestionOrSuggestionFollowUpState new]],nil]]]],
                [RepeatOnce create:[USuggestionFeedbackState createWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch]], nil];
    }
    return self;
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    return [[FHProposalState alloc] initWithActionFeedback:actionFeedback restaurantSearch:restaurantSearch];
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_concatenation consume:token];
}

@end
