//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UDidResolveProblemWithAccessLocationServiceState.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "SearchAction.h"
#import "RestaurantSearch.h"
#import "UCuisinePreference.h"


@implementation UDidResolveProblemWithAccessLocationServiceState {
}

+ (instancetype)createWithActionFeedback:(id <ConversationSource>)actionFeedback {
    return [[UDidResolveProblemWithAccessLocationServiceState alloc] initWithActionFeedback:actionFeedback tokenclass:UDidResolveProblemWithAccessLocationService .class];
}

@end