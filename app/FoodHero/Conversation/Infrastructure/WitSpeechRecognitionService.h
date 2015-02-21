//
// Created by Jorg on 16/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISpeechRecognitionService.h"
#import "ISchedulerFactory.h"
#import "IAudioSession.h"

@interface WitSpeechRecognitionService : NSObject <ISpeechRecognitionService>

- (instancetype)initWithAccessToken:(NSString *)accessToken audioSession:(id <IAudioSession>)audioSession;

@end