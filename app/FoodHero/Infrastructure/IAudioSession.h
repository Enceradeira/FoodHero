//
// Created by Jorg on 24/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@import AVFoundation;

#import <Foundation/Foundation.h>

@protocol IAudioSession <NSObject>
- (void)requestRecordPermission:(void (^)(BOOL granted))response;

- (AVAudioSessionRecordPermission)recordPermission;
@end