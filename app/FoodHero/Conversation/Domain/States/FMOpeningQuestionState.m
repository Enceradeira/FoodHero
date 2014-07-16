//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FMOpeningQuestionState.h"
#import "FHOpeningQuestionAction.h"


@implementation FMOpeningQuestionState {
}
- (ConversationAction *)createAction {
    return [FHOpeningQuestionAction create];
}

@end