//
// Created by Jorg on 18/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import "SoundPlayer.h"


@implementation SoundPlayer {

    Sound *_sound;
    SystemSoundID _soundID;
    id <PlaySoundDelegate> _delegate;
}
- (void)play:(Sound *)sound delay:(NSTimeInterval)delay {

    _sound = sound;

    [NSTimer scheduledTimerWithTimeInterval:delay
                                     target:self selector:@selector(soundWillPlay:) userInfo:nil repeats:NO];


    [NSTimer scheduledTimerWithTimeInterval:sound.length + delay
                                     target:self selector:@selector(soundDidFinish:) userInfo:nil repeats:NO];
}

- (id <PlaySoundDelegate>)delegate {
    return _delegate;
}

- (void)setDelegate:(id <PlaySoundDelegate>)delegate {
    _delegate = delegate;
}

- (void)soundWillPlay:(id)soundWillPlay {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:_sound.file ofType:_sound.type];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundUrl, &_soundID);
    AudioServicesPlaySystemSound(_soundID);

}

- (void)soundDidFinish:(id)userInfo {
    AudioServicesDisposeSystemSoundID(_soundID);

    if (_delegate != nil) {
        [_delegate soundDidFinish];
    }
}


@end