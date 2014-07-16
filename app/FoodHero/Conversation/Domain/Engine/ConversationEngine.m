//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationEngine.h"
#import "FHConversationState.h"


@implementation ConversationEngine {
    FHConversationState *_state;
}
- (id)init {
    self = [super init];
    if (self != nil) {
        _state = [FHConversationState new];
    }
    return self;
}

- (ConversationAction *)consume:(ConversationToken *)input {
    return [_state consume:input];
}
@end