//
// Created by Jorg on 16/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@protocol ISpeechRecognitionService <NSObject>
- (void)interpretString:(NSString *)string state:(NSString*)state;

- (void)recordAndInterpretUserVoice:(NSString *)state;

- (enum AVAudioSessionRecordPermission)recordPermission;

- (RACSignal *)output;
@end