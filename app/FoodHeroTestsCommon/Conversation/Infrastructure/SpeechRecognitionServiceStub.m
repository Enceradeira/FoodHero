//
// Created by Jorg on 17/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SpeechRecognitionServiceStub.h"
#import "SpeechInterpretation.h"


@interface SpeechRecognitionServiceStub ()
@property(atomic, readwrite) SpeechInterpretation *interpretation;
@end

@implementation SpeechRecognitionServiceStub {
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
    return [self getInterpretationSignal];
}

- (void)injectInterpretation:(SpeechInterpretation *)interpretation {
    self.interpretation = interpretation;
}

@end