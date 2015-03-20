//
// Created by Jorg on 16/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "WITRecordingSession.h"
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "WitSpeechRecognitionService.h"
#import "SpeechInterpretation.h"
#import "FoodHero-Swift.h"

@interface WitDelegate : NSObject <WitDelegate>
+ (id <WitDelegate>)create:(id <RACSubscriber>)subscriber simulateNetworkError:(BOOL)error state:(NSString *)state;

- (id)init:(id <RACSubscriber>)subscriber simulateNetworkError:(BOOL)simulateNetworkError state:(NSString *)state;
@end

@implementation WitDelegate {

    id <RACSubscriber> _subscriber;
    BOOL _simulateNetworkError;
    NSString *_state;
}
- (void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id)customData error:(NSError *)error {
    SpeechInterpretation *interpretation = [SpeechInterpretation new];
    if (error != nil || _simulateNetworkError) {
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] || _simulateNetworkError) {
            [_subscriber sendNext:[NetworkError new]];
        }
        else {
            NSLog([NSString stringWithFormat:@"WitDelegate detected unexptected error '%@'. It will handle it as UserIntentUnclearError", [error domain]]);
            [_subscriber sendNext:[self userIntentUnclearError]];
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
            [_subscriber sendNext:[self userIntentUnclearError]];
        }
        else {
            [_subscriber sendNext:interpretation];
        }
    }
    else {
        [_subscriber sendNext:[self userIntentUnclearError]];
    }
}

- (UserIntentUnclearError *)userIntentUnclearError {
    return [[UserIntentUnclearError alloc] initWithState:_state];
}

- (void)witActivityDetectorStarted {

}

- (void)witDidStartRecording {
    NSLog(@"Recording startet");
}

- (void)witDidStopRecording {
    NSLog(@"Recording stopped");
}


- (id)init:(id <RACSubscriber>)subscriber simulateNetworkError:(BOOL)simulateNetworkError state:(NSString *)state {
    self = [super init];
    if (self) {
        _subscriber = subscriber;
        _simulateNetworkError = simulateNetworkError;
        _state = state;
    }
    return self;
}

+ (id <WitDelegate>)create:(id <RACSubscriber>)subscriber simulateNetworkError:(BOOL)error state:(NSString *)state {
    return [[WitDelegate alloc] init:subscriber simulateNetworkError:error state:state];
}

@end

@implementation WitSpeechRecognitionService {

    NSString *_accessToken;
    Wit *_configuredWit;
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
    }

    return self;
}

- (void)setContext:(NSString *)state subscriber:(id <RACSubscriber>)subscriber {
    [self.wit setContext:@{@"state" : state}];
    self.wit.delegate = [WitDelegate create:subscriber simulateNetworkError:_simulateNetworkError state:state];
}

- (Wit *)wit {
    if (!_configuredWit) {
        _configuredWit = [Wit sharedInstance];
        _configuredWit.accessToken = _accessToken;
        _configuredWit.detectSpeechStop = WITVadConfigDetectSpeechStop;
    }
    return _configuredWit;
}

- (void)interpretString:(NSString *)string state:(NSString *)state {
    [self setContext:state subscriber:_output];

    [self.wit interpretString:string customData:state];
}

- (void)recordAndInterpretUserVoice:(NSString *)state {
    [_audioSession requestRecordPermission:^(BOOL granted) {
        if (granted) {
            [self setContext:state subscriber:_output];
            [self.wit start];
        }
        else {
            assert(false); // TODO error-handling
        }
    }];
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