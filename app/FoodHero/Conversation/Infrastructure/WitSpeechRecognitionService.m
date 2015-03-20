//
// Created by Jorg on 16/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "WITRecordingSession.h"
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "WitSpeechRecognitionService.h"
#import "SpeechInterpretation.h"
#import "FoodHero-Swift.h"

@implementation WitSpeechRecognitionService {

    NSString *_accessToken;
    Wit *_wit;
    id <IAudioSession> _audioSession;
    RACSubject *_output;
    BOOL _simulateNetworkError;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken audioSession:(id <IAudioSession>)audioSession {
    self = [super init];
    if (self) {
        _accessToken = accessToken;
        _audioSession = audioSession;
        _output = [RACSubject new];
        _simulateNetworkError = NO;

        _wit = [Wit sharedInstance];
        _wit.accessToken = _accessToken;
        _wit.detectSpeechStop = WITVadConfigDetectSpeechStop;
        _wit.delegate = self;
    }

    return self;
}

- (void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id)customData error:(NSError *)error {
    SpeechInterpretation *interpretation = [SpeechInterpretation new];
    if (error != nil || _simulateNetworkError) {
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] || _simulateNetworkError) {
            [_output sendNext:[NetworkError new]];
        }
        else {
            NSLog([NSString stringWithFormat:@"WitDelegate detected unexptected error '%@'. It will handle it as UserIntentUnclearError", [error domain]]);
            [_output sendNext:[self userIntentUnclearError]];
        }
    }
    else if (outcomes.count > 0) {
        NSDictionary *best = outcomes[0];
        interpretation.confidence = [best[@"confidence"] doubleValue];
        interpretation.text = best[@"_text"];
        interpretation.intent = best[@"intent"];
        NSDictionary *entities = best[@"entities"];
        interpretation.entities = [[entities.allValues linq_selectMany:^(NSArray *dic) {
            return dic;
        }] linq_select:^(NSDictionary *dic) {
            return dic[@"value"];
        }];
        if (interpretation.confidence < 0.1) {
            [_output sendNext:[self userIntentUnclearError]];
        }
        else {
            [_output sendNext:interpretation];
        }
    }
    else {
        [_output sendNext:[self userIntentUnclearError]];
    }
    [self.stateSource didStopProcessingUserInput];
}

- (UserIntentUnclearError *)userIntentUnclearError {
    return [[UserIntentUnclearError alloc] initWithState:[self.stateSource getState]];
}

- (void)witActivityDetectorStarted {

}

- (void)witDidStartRecording {
    [self startProcessingUserInput];
    NSLog(@"Recording startet");
}

- (void)witDidStopRecording {
    NSLog(@"Recording stopped");
}

- (void)interpretString:(NSString *)string {
    [self startProcessingUserInput];
    [_wit interpretString:string customData:nil];
}

- (void)startProcessingUserInput {
    [self.stateSource didStartProcessingUserInput];
    NSString* state = [self.stateSource getState];
    [_wit setContext:@{@"state" : state}];
}

- (AVAudioSessionRecordPermission)recordPermission {
    return [_audioSession recordPermission];
}

- (RACSignal *)output {
    return _output;
}

- (void)simulateNetworkError:(BOOL)simulationEnabled {
    _simulateNetworkError = simulationEnabled;
}


@end