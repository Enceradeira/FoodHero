//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UGoodByeState.h"
#import "UGoodBye.h"
#import "AskUserWhatToDoAfterGoodByeAction.h"
#import "AddTokenAction.h"
#import "FHGoodByeAfterSuccess.h"


@implementation UGoodByeState {

}

- (instancetype)init {
    self = [super initWithToken:[UGoodBye class]];
    return self;
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}


@end