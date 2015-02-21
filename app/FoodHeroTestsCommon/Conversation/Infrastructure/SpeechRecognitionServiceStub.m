//
// Created by Jorg on 17/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@import AVFoundation;

#import "SpeechRecognitionServiceStub.h"
#import "SpeechInterpretation.h"
#import "MissingAudioRecordionPermissonError.h"


@interface SpeechRecognitionServiceStub ()
@property(atomic, readwrite) SpeechInterpretation *interpretation;
@end

@implementation SpeechRecognitionServiceStub {
    AVAudioSessionRecordPermission _permission;
    RACSubject *_output;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _permission = AVAudioSessionRecordPermissionGranted;
        _output = [RACSubject new];

        [[RACObserve(self, self.interpretation) filter:^(SpeechInterpretation *i) {
            return (BOOL) (i != nil);
        }] subscribeNext:^(SpeechInterpretation *i) {
            [_output sendNext:i];
        }];
    }

    return self;
}

- (void)interpretString:(NSString *)string state:(id)customData {
}

- (void)recordAndInterpretUserVoice:(NSString *)state {
    if (_permission != AVAudioSessionRecordPermissionGranted) {
        [_output sendNext:[MissingAudioRecordionPermissonError new]];
    }
}

- (void)injectInterpretation:(SpeechInterpretation *)interpretation {
    self.interpretation = interpretation;
}

- (AVAudioSessionRecordPermission)recordPermission {
    return _permission;
}

- (RACSignal *)output {
    return _output;
}

- (void)injectRecordPermission:(AVAudioSessionRecordPermission)permission {
    _permission = permission;
}

@end