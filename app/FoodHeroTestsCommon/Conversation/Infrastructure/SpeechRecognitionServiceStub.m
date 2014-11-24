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
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _permission =AVAudioSessionRecordPermissionGranted;
    }

    return self;
}


- (RACSignal *)getInterpretationSignal {
    RACSignal *values = RACObserve(self, self.interpretation);
    return [[values filter:^(SpeechInterpretation *i) {
        return (BOOL) (i != nil);
    }] take:1];
}

- (RACSignal *)interpretString:(NSString *)string state:(id)customData {
    return [self getInterpretationSignal];
}

- (RACSignal *)recordAndInterpretUserVoice:(NSString *)state {
    if (_permission != AVAudioSessionRecordPermissionGranted) {
        return [RACSignal createSignal:^(id <RACSubscriber> subscriber) {
            [subscriber sendError:[MissingAudioRecordionPermissonError new]];
            return (RACDisposable *) nil;
        }];
    }
    return [self getInterpretationSignal];
}

- (void)injectInterpretation:(SpeechInterpretation *)interpretation {
    self.interpretation = interpretation;
}

- (AVAudioSessionRecordPermission)recordPermission {
    return _permission;
}

- (void)injectRecordPermission:(AVAudioSessionRecordPermission)permission {
    _permission = permission;
}

@end