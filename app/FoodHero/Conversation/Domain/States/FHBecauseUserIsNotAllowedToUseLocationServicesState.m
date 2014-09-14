//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHBecauseUserIsNotAllowedToUseLocationServicesState.h"
#import "FHBecauseUserIsNotAllowedToUseLocationServices.h"

@implementation FHBecauseUserIsNotAllowedToUseLocationServicesState {
}
- (id)init {
    return [super initWithToken:FHBecauseUserIsNotAllowedToUseLocationServices.class];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}
@end