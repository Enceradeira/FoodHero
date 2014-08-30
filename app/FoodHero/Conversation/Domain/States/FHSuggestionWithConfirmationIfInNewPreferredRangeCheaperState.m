//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCheaperState.h"
#import "Alternation.h"
#import "FHConfirmationIfInNewPreferredRangeCheaper.h"
#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper.h"
#import "AskUserSuggestionFeedbackAction.h"


@implementation FHSuggestionWithConfirmationIfInNewPreferredRangeCheaperState {
}

- (instancetype)init {
    return (FHSuggestionWithConfirmationIfInNewPreferredRangeCheaperState *) [super initWithToken:[FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper class]];
}

+ (FHSuggestionWithConfirmationIfInNewPreferredRangeCheaperState *)create {
    return [[FHSuggestionWithConfirmationIfInNewPreferredRangeCheaperState alloc] init];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [AskUserSuggestionFeedbackAction new];
}



@end