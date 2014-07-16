//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHBecauseUserIsNotAllowedToUseLocationServicesState.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"

@implementation FHBecauseUserIsNotAllowedToUseLocationServicesState {
}
- (id <ConversationAction>)createAction {
    return [AskUserIfProblemWithAccessLocationServiceResolved new];
}
@end