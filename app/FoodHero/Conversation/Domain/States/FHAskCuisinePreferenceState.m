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
- (instancetype)init{
    self = [super init];
    if (self) {
        _concatenation = [Concatenation create:
                [RepeatOnce create:[FMOpeningQuestionState new]],
                [RepeatOnce create:[UCuisinePreferenceState new]], nil];
    }

    return self;
}

- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_concatenation consume:token];
}


@end