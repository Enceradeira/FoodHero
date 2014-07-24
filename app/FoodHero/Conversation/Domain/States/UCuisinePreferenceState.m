//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreferenceState.h"
#import "SearchAction.h"
#import "UCuisinePreference.h"


@implementation UCuisinePreferenceState {
}

+ (UCuisinePreferenceState *)createWithActionFeedback:(id <ConversationSource>)actionFeedback {
    return [[UCuisinePreferenceState alloc] initWithActionFeedback:actionFeedback tokenclass:UCuisinePreference.class];
}

@end