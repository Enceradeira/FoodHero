//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHWhatToDoNextState.h"
#import "FHWhatToDoNext.h"
#import "AskUserWhatToDoNextAction.h"


@implementation FHWhatToDoNextState {

}

- (id)init {
    return [super initWithToken:[FHWhatToDoNext class]];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [AskUserWhatToDoNextAction new];
}


@end