//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHBecauseUserIsNotAllowedToUseLocationServicesState.h"
#import "NoAction.h"
#import "ConversationToken.h"


@implementation FHBecauseUserIsNotAllowedToUseLocationServicesState {
}
- (ConversationAction *)createAction {
    return [NoAction new];
}
@end