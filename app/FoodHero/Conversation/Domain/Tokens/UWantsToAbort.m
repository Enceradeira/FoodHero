//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UWantsToAbort.h"
#import "SearchAction.h"
#import "AskUserWhatToDoNextAction.h"
#import "FHWhatToDoNextCommentAfterSuccess.h"
#import "AddTokenAction.h"
#import "FHWhatToDoNextCommentAfterFailure.h"


@implementation UWantsToAbort {
}
- (id)init {
    return [super initWithSemanticId:@"U:WantsToAbort" text:@"Just forget about it"];
}

- (id <ConversationAction>)createAction {
    return [AddTokenAction create:[FHWhatToDoNextCommentAfterFailure new]];
}
@end
