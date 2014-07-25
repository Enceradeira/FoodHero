//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHGoodByeAfterSuccessState.h"
#import "FHGoodByeAfterSuccess.h"
#import "AskUserWhatToDoAfterGoodByeAction.h"


@implementation FHGoodByeAfterSuccessState {

}
- (instancetype)init {
    self = [super initWithToken:[FHGoodByeAfterSuccess class]];
    return self;
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [AskUserWhatToDoAfterGoodByeAction new];
}


@end