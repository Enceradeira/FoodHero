//
// Created by Jorg on 17/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISpeechRecognitionService.h"

@class SpeechInterpretation;


@interface SpeechRecognitionServiceStub : NSObject <ISpeechRecognitionService>
- (void)injectInterpretation:(SpeechInterpretation *)interpretation;
@end