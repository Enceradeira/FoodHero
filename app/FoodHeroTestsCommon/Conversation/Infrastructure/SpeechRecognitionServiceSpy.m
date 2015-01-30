//
// Created by Jorg on 22/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SpeechRecognitionServiceSpy.h"
#import "SpeechInterpretation.h"



@implementation SpeechRecognitionServiceSpy {

    SpeechInterpretation *_interpretation;
}
- (RACSignal *)interpretString:(NSString *)string state:(NSString *)state {
    _lastInterpretedString = string;
    _lastState = state;

    return [RACSignal return:_interpretation ? _interpretation : [SpeechInterpretation new]];
}

- (void)injectInterpretation:(SpeechInterpretation *)interpretation {
    _interpretation = interpretation;
}


- (RACSignal *)recordAndInterpretUserVoice:(NSString *)state{
    return [RACSignal empty];
}

- (AVAudioSessionRecordPermission)recordPermission {
    return AVAudioSessionRecordPermissionGranted;
}

@end