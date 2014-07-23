//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHAskCuisinePreferenceState.h"
#import "Concatenation.h"
#import "RepeatOnce.h"
#import "FMOpeningQuestionState.h"
#import "UCuisinePreferenceState.h"
#import "ConversationSource.h"


@implementation FHAskCuisinePreferenceState {

    Concatenation *_concatenation;
}
- (instancetype)initWithActionFeedback:(id <ConversationSource>)actionFeedback {
    self = [super init];
    if (self) {
        _concatenation = [Concatenation create:
                [RepeatOnce create:[FMOpeningQuestionState new]],
                [RepeatOnce create:[UCuisinePreferenceState createWithActionFeedback:actionFeedback]], nil];
    }

    return self;
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback {
    return [[FHAskCuisinePreferenceState alloc] initWithActionFeedback:actionFeedback];
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_concatenation consume:token];
}

- (BOOL)isInState:(Class)state {
    if( self.class == state){
        return YES;
    }
    return [_concatenation isInState:state];
}


@end