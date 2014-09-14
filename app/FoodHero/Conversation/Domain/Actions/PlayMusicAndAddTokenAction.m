//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "PlayMusicAndAddTokenAction.h"


@implementation PlayMusicAndAddTokenAction {

    ConversationToken *_token;
}

- (instancetype)initWith:(ConversationToken *)token {
    self = [super init];
    if (self != nil) {
        _token = token;
    }
    return self;
}

- (void)execute:(id <ConversationSource>)conversationSource {
    [conversationSource addToken:_token];
}

+ (instancetype)create:(ConversationToken *)token {
    return [[PlayMusicAndAddTokenAction alloc] initWith:token];
}


@end