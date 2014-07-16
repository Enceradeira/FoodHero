//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FMOpeningQuestionState.h"
#import "AskUserCuisinePreferenceAction.h"


@implementation FMOpeningQuestionState {
}
- (id<ConversationAction>)createAction {
    return [AskUserCuisinePreferenceAction create];
}

@end