//
// Created by Jorg on 22/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISpeechRecognitionService.h"

@class SpeechInterpretation;


@interface SpeechRecognitionServiceSpy : NSObject <ISpeechRecognitionService>
@property(readonly, nonatomic) NSString *lastInterpretedString;
@property(readonly, nonatomic) NSString *lastState;

- (void)injectInterpretation:(SpeechInterpretation *)interpretation;
@end