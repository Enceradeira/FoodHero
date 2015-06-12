//
// Created by Jorg on 16/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Wit.h>
#import "ISpeechRecognitionService.h"
#import "ISchedulerFactory.h"
#import "IAudioSession.h"
#import "ISpeechRecognitionStateSource.h"

@interface WitSpeechRecognitionService : NSObject <ISpeechRecognitionService, WitDelegate>

@property(weak, nonatomic) id <ISpeechRecognitionStateSource> stateSource;

- (instancetype)initWithAccessToken:(NSString *)accessToken audioSession:(id <IAudioSession>)audioSession;

+ (void)sendToGAI;
@end