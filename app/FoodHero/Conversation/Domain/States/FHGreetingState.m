//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHGreetingState.h"
#import "FHGreeting.h"


@implementation FHGreetingState {
}
- (id)init {
    return [super initWithToken:FHGreeting.class];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}

@end