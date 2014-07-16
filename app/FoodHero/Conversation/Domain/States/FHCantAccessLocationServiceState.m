//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHCantAccessLocationServiceState.h"
#import "FHBecauseUserIsNotAllowedToUseLocationServices.h"
#import "FHBecauseUserDeniedAccessToLocationServices.h"
#import "FHBecauseUserDeniedAccessToLocationServicesState.h"
#import "FHBecauseUserIsNotAllowedToUseLocationServicesState.h"


@implementation FHCantAccessLocationServiceState {
}
- (id <ConversationAction>)consume:(ConversationToken *)token {
    if (token.class == [FHBecauseUserDeniedAccessToLocationServices class]) {
        return [[FHBecauseUserDeniedAccessToLocationServicesState new] createAction];
    }
    else if (token.class == [FHBecauseUserIsNotAllowedToUseLocationServices class]) {
        return [[FHBecauseUserIsNotAllowedToUseLocationServicesState new] createAction];
    }
    return nil;
}
@end