//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FMGreetingState.h"
#import "FHGreetingAction.h"


@implementation FMGreetingState {
}
- (ConversationAction *)createAction {
    return [FHGreetingAction create];
}
@end