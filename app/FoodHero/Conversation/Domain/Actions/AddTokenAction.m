//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AddTokenAction.h"
#import "FHWhatToDoNextCommentAfterSuccess.h"


@implementation AddTokenAction {
    ConversationToken *_token;
}

+ (instancetype)create:(ConversationToken *)token {
    return [[AddTokenAction alloc] initWithToken:token];
}

- (instancetype)initWithToken:(ConversationToken *)token {
    self = [super init];
    if (self != nil) {
        _token = token;
    }
    return self;
}

- (void)execute:(id <ConversationSource>)conversationSource {
    [conversationSource addFHToken:_token];
}


@end