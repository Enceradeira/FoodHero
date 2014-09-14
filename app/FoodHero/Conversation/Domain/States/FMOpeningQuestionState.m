//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FMOpeningQuestionState.h"
#import "AskUserCuisinePreferenceAction.h"
#import "FHOpeningQuestion.h"


@implementation FMOpeningQuestionState {
}

- (id)init {
    return [super initWithToken:FHOpeningQuestion.class];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}
@end