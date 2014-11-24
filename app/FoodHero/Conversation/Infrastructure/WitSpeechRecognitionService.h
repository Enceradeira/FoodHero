//
// Created by Jorg on 16/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISpeechRecognitionService.h"
#import "ISchedulerFactory.h"


@interface WitSpeechRecognitionService : NSObject <ISpeechRecognitionService>

- (instancetype)initWithSchedulerFactory:(id <ISchedulerFactory>)schedulerFactory accessToken:(NSString *)accessToken;

@end