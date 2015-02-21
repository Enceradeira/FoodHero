//
// Created by Jorg on 22/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SpeechRecognitionServiceSpy.h"


@implementation SpeechRecognitionServiceSpy {

    SpeechInterpretation *_interpretation;
    RACSubject *_output;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _output = [RACSubject new];
    }
    return self;
}

- (void)interpretString:(NSString *)string state:(NSString *)state {
    _lastInterpretedString = string;
    _lastState = state;

    [_output sendNext:_interpretation ? _interpretation : [SpeechInterpretation new]];
}

- (void)injectInterpretation:(SpeechInterpretation *)interpretation {
    _interpretation = interpretation;
}


- (void)recordAndInterpretUserVoice:(NSString *)state {
}

- (AVAudioSessionRecordPermission)recordPermission {
    return AVAudioSessionRecordPermissionGranted;
}

- (RACSignal *)output {
    return _output;
}


@end