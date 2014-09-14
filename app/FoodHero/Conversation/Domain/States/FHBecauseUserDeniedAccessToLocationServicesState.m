//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHBecauseUserDeniedAccessToLocationServicesState.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"
#import "FHBecauseUserDeniedAccessToLocationServices.h"


@implementation FHBecauseUserDeniedAccessToLocationServicesState {
}
- (id)init {
    return [super initWithToken:FHBecauseUserDeniedAccessToLocationServices.class];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}

@end