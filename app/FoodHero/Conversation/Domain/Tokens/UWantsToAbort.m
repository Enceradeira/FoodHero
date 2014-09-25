//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UWantsToAbort.h"
#import "SearchAction.h"
#import "AskUserWhatToDoNextAction.h"
#import "FHWhatToDoNextAfterSuccess.h"
#import "AddTokenAction.h"
#import "FHWhatToDoNextAfterFailure.h"


@implementation UWantsToAbort {
}
- (id)init {
    return [super initWithSemanticId:@"U:WantsToAbort" text:@"Just forget about it!"];
}

- (id <ConversationAction>)createAction {
    return [AddTokenAction create:[FHWhatToDoNextAfterFailure new]];
}
@end
