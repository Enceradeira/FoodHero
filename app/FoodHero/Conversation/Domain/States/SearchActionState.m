//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SearchActionState.h"
#import "SearchAction.h"
#import "UCuisinePreference.h"


@implementation SearchActionState {
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [SearchAction new];
}

@end