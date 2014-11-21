//
// Created by Jorg on 17/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SpeechRecognitionServiceStub.h"
#import "SpeechInterpretation.h"


@implementation SpeechRecognitionServiceStub {

    SpeechInterpretation *_interpretation;
}
- (RACSignal *)interpretString:(NSString *)string customData:(id)customData {
    return [RACSignal return:_interpretation ? _interpretation : [SpeechInterpretation new]];
}

- (void)injectInterpretation:(SpeechInterpretation *)interpretation {
    _interpretation = interpretation;
}

@end