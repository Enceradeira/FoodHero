//
// Created by Jorg on 17/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@import AVFoundation;

#import <Foundation/Foundation.h>
#import "ISpeechRecognitionService.h"
#import "ISpeechRecognitionStateSource.h"

@class SpeechInterpretation;


@interface SpeechRecognitionServiceStub : NSObject <ISpeechRecognitionService>
@property(weak, nonatomic) id <ISpeechRecognitionStateSource> stateSource;

@property(readonly, nonatomic) NSString *state;
@property(readonly, nonatomic) NSString *threadId;

- (void)injectInterpretation:(SpeechInterpretation *)interpretation;

- (void)injectRecordPermission:(AVAudioSessionRecordPermission)permission;
@end