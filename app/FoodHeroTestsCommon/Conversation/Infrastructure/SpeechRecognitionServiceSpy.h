//
// Created by Jorg on 17/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@import AVFoundation;

#import <Foundation/Foundation.h>
#import "ISpeechRecognitionService.h"
#import "ISpeechRecognitionStateSource.h"

@class SpeechInterpretation;


@interface SpeechRecognitionServiceSpy : NSObject <ISpeechRecognitionService>
@property(readonly, nonatomic) NSString *state;

@end