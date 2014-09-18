//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "PlaySoundAndAfterAddTokenAction.h"
#import "DesignByContractException.h"
#import "TyphoonComponents.h"
#import "ISoundPlayer.h"


@interface PlaySoundAndAfterAddTokenAction () <PlaySoundDelegate>
@end

@implementation PlaySoundAndAfterAddTokenAction {

    ConversationToken *_token;
    id <ConversationSource> _conversationSource;
    Sound *_sound;
}

- (void)execute:(id <ConversationSource>)conversationSource {
    _conversationSource = conversationSource;

    id <ISoundPlayer> soundPlayer = [(id <ApplicationAssembly>) [TyphoonComponents factory] soundPlayer];
    [soundPlayer setDelegate:self];
    [soundPlayer play:_sound delay:2];
}


- (instancetype)initWith:(ConversationToken *)token sound:(Sound *)sound {
    self = [super init];
    if (self != nil) {
        _token = token;
        _sound = sound;
    }
    return self;
}


- (void)soundDidFinish {

    if (_conversationSource == nil) {
        [DesignByContractException createWithReason:@"conversationSource should not be nil here"];
    }
    else {
        [_conversationSource addToken:_token];
    }
}

+ (id <ConversationAction>)create:(ConversationToken *)token sound:(Sound *)sound {
    return [[PlaySoundAndAfterAddTokenAction alloc] initWith:token sound:sound];
}


@end