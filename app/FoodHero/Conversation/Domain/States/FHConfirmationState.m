//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHConfirmationState.h"
#import "NoAction.h"
#import "FHGreeting.h"
#import "FHConfirmation.h"


@implementation FHConfirmationState {
}
- (id)init {
    return [super initWithToken:FHConfirmation.class];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [NoAction new];
}

@end