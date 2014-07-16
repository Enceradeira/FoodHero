//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FMGreetingState.h"
#import "NoAction.h"


@implementation FMGreetingState {
}
- (ConversationAction *)createAction {
    return [NoAction create];
}
@end