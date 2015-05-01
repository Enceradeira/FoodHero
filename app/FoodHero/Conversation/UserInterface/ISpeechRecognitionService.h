//
// Created by Jorg on 16/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "ISpeechRecognitionStateSource.h"

@protocol ISpeechRecognitionService <NSObject>

@property(weak, nonatomic) id <ISpeechRecognitionStateSource> stateSource;

- (void)interpretString:(NSString *)string;

- (enum AVAudioSessionRecordPermission)recordPermission;

- (RACSignal *)output;

- (void)simulateNetworkError:(BOOL)simulationEnabled;

- (void)setState:(NSString *)state;
@end