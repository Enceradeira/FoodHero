//
// Created by Jorg on 17/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@import AVFoundation;

#import "SpeechRecognitionServiceStub.h"
#import "SpeechInterpretation.h"

@implementation SpeechRecognitionServiceStub {
    AVAudioSessionRecordPermission _permission;
    RACSubject *_output;
    NSMutableArray *_interpretations;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _permission = AVAudioSessionRecordPermissionGranted;
        _output = [RACSubject new];
        _interpretations = [NSMutableArray new];

        /*
        [[RACObserve(self, self.interpretation) filter:^(SpeechInterpretation *i) {
            return (BOOL) (i != nil);
        }] subscribeNext:^(SpeechInterpretation *i) {
            [_output sendNext:i];
        }];*/
    }

    return self;
}

- (void)interpretString:(NSString *)string {
    [self generateOutput];
}

- (void)generateOutput {
    if (_permission != AVAudioSessionRecordPermissionGranted) {
        // [_output sendNext:[MissingAudioRecordionPermissonError new]];
        assert(false); // TODO error-handling
    }
    else {
        assert(_interpretations.count > 0);
        SpeechInterpretation *i = _interpretations[0];
        [_interpretations removeObjectAtIndex:0];
        [_output sendNext:i];
    }
}

- (void)injectInterpretation:(SpeechInterpretation *)interpretation {
    [_interpretations addObject:interpretation];
}

- (AVAudioSessionRecordPermission)recordPermission {
    return _permission;
}

- (RACSignal *)output {
    return _output;
}

- (void)simulateNetworkError:(BOOL)simulationEnabled {

}

- (void)setState:(NSString *)state {
    _state = state;
}

- (void)setThreadId:(NSString *)id {
    _threadId = id;
}


- (void)injectRecordPermission:(AVAudioSessionRecordPermission)permission {
    _permission = permission;
}

@end