//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import "PlaySoundAndAfterAddTokenAction.h"
#import "DesignByContractException.h"
#import "Sound.h"


@implementation PlaySoundAndAfterAddTokenAction {

    ConversationToken *_token;
    SystemSoundID _soundID;
    id <PlaySoundAndAfterAddTokenActionDelegate> _delgate;
    id <ConversationSource> _conversationSource;
    Sound *_sound;
}

- (void)execute:(id <ConversationSource>)conversationSource {
    _conversationSource = conversationSource;

    NSString *soundPath = [[NSBundle mainBundle] pathForResource:_sound.file ofType:_sound.type];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundUrl, &_soundID);
    AudioServicesPlaySystemSound(_soundID);

    [NSTimer scheduledTimerWithTimeInterval:_sound.length
                                     target:self selector:@selector(soundDidFinish:) userInfo:conversationSource repeats:NO];
}

- (instancetype)initWith:(ConversationToken *)token sound:(Sound *)sound {
    self = [super init];
    if (self != nil) {
        _token = token;
        _sound = sound;
    }
    return self;
}


- (void)soundDidFinish:(id)userInfo {
    AudioServicesDisposeSystemSoundID(_soundID);

    if (_conversationSource == nil) {
        [DesignByContractException createWithReason:@"conversationSource should not be nil here"];
    }
    else {
        [_conversationSource addToken:_token];
    }
    [_delgate soundDidFinish];
}


- (void)setDelegate:(id <PlaySoundAndAfterAddTokenActionDelegate>)delegate {
    _delgate = delegate;
}

+ (id <ConversationAction>)create:(ConversationToken *)token sound:(Sound *)sound {
    return [[PlaySoundAndAfterAddTokenAction alloc] initWith:token sound:sound];
}


@end