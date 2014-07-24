//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UTryAgainNowState.h"
#import "UTryAgainNow.h"
#import "UCuisinePreference.h"

@implementation UTryAgainNowState {
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback {
    return [[UTryAgainNowState alloc] initWithActionFeedback:actionFeedback tokenclass:UTryAgainNow.class];
}
@end