//
// Created by Jorg on 20/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISpeechRecognitionStateSource <NSObject>
- (NSString *)getState;

// fired when voice or text processing finished
- (void)didStopProcessingUserInput;

// fired when voice or text processing started
- (void)didStartProcessingUserInput;

// fired when recording started
- (void)didStopRecordingUserInput;

// fired when recording stopped
- (void)didStartRecordingUserInput;
@end