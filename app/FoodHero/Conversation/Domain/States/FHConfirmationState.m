//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHConfirmationState.h"
#import "FHConfirmation.h"


@implementation FHConfirmationState {
}
- (id)init {
    self = [super initWithToken:FHConfirmation.class];
    return self;
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}

@end