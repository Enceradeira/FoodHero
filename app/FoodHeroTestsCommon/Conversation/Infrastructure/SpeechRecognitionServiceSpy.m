//
// Created by Jorg on 17/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@import AVFoundation;

#import "SpeechRecognitionServiceSpy.h"

@implementation SpeechRecognitionServiceSpy
- (id <ISpeechRecognitionStateSource>)stateSource {
    return nil;
}

- (void)setStateSource:(id <ISpeechRecognitionStateSource>)stateSource {

}

- (void)interpretString:(NSString *)string {

}

- (enum AVAudioSessionRecordPermission)recordPermission {
    return AVAudioSessionRecordPermissionGranted;
}

- (RACSignal *)output {
    return [RACSignal empty];
}

- (void)simulateNetworkError:(BOOL)simulationEnabled {

}

- (void)setState:(NSString *)state {
    _state = state;
}


@end