//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHCantAccessLocationServiceState.h"
#import "FHBecauseUserIsNotAllowedToUseLocationServices.h"
#import "FHBecauseUserDeniedAccessToLocationServices.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"


@implementation FHCantAccessLocationServiceState {
}
- (id<ConversationAction>)consume:(ConversationToken *)token {
    if (token.class == [FHBecauseUserDeniedAccessToLocationServices class]) {
        return [AskUserIfProblemWithAccessLocationServiceResolved new];
    }
    else if (token.class == [FHBecauseUserIsNotAllowedToUseLocationServices class]) {
        return [AskUserIfProblemWithAccessLocationServiceResolved new];
    }
    return nil;
}
@end