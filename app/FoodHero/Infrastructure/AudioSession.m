//
// Created by Jorg on 24/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@import AVFoundation;

#import "AudioSession.h"

@implementation AudioSession {

}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self configureForWit];
    }
    return self;
}

- (void)configureForWit {
    // the category requested by wit
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)requestRecordPermission:(void (^)(BOOL granted))response {
    [[AVAudioSession sharedInstance] requestRecordPermission:response];
}

- (AVAudioSessionRecordPermission)recordPermission {
    return [AVAudioSession sharedInstance].recordPermission;
}

- (void)playSoundWithId:(SystemSoundID)id {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    @try {
        AudioServicesPlaySystemSound(id);
    }
    @finally {
        [self configureForWit];
    }
}

- (void)playJblBeginSound {
    // https://github.com/TUNER88/iOSSystemSoundsLibrary
    // http://iphonedevwiki.net/index.php/AudioServices
    [self playSoundWithId:1110];
}

- (void)playJblCancelSound {
    [self playSoundWithId:1112];
}


@end