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
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    return self;
}

- (void)requestRecordPermission:(void (^)(BOOL granted))response {
    [[AVAudioSession sharedInstance] requestRecordPermission:response];
}

- (AVAudioSessionRecordPermission)recordPermission {
    return [AVAudioSession sharedInstance].recordPermission;
}


@end