//
// Created by Jorg on 16/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "WITRecordingSession.h"
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "WitSpeechRecognitionService.h"
#import "SpeechInterpretation.h"

@implementation WitSpeechRecognitionService {

    NSString *_accessToken;
    Wit *_wit;
    id <IAudioSession> _audioSession;
    RACSubject *_output;
    BOOL _simulateNetworkError;
    NSString *_currState;
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
            [self sendNextToOutput:[NetworkError new] GAIAction:[GAIActions witUErrors] GAILabel:@"NSURLErrorDomain"];
        }
        else {
            NSLog(@"WitDelegate detected unexptected error '%@'. It will handle it as UserIntentUnclearError", [error domain]);
            [self sendNextToOutput:[self userIntentUnclearError] GAIAction:[GAIActions witUErrors] GAILabel:@"Unexpected"];
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


        // Workaround to fix problem that several intents can't have same expression
        if ([_currState isEqualToString:@"askForSuggestionFeedback"]
                && ([interpretation.text isEqualToString:@"no"] || [interpretation.text isEqualToString:@"No"])) {

            NSLog(@"WIT Workaround applied: %@ -> SuggestionFeedback_Dislike ", interpretation.intent);
            interpretation.intent = @"SuggestionFeedback_Dislike";
            interpretation.confidence = 1;
        }

        if (interpretation.confidence < 0.1 || [interpretation.intent isEqualToString:@"UNKNOWN"]) {
            [self sendNextToOutput:[self userIntentUnclearError] GAIAction:[GAIActions witUErrors] GAILabel:@"LowConfidence"];
        }
        else {
            [self sendNextToOutput:interpretation GAIAction:interpretation.intent GAILabel:@""];
        }
    }
    else {
        [_output sendNext:[self userIntentUnclearError]];
    }
    [self.stateSource didStopProcessingUserInput];
}

- (void)sendNextToOutput:(id)value GAIAction:(NSString *)GAIAction GAILabel:(NSString *)GAILabel {
    [_output sendNext:value];
    [self logGAIEventWithAction:GAIAction label:GAILabel];
}

- (UserIntentUnclearError *)userIntentUnclearError {
    return [[UserIntentUnclearError alloc] initWithState:_currState expectedUserUtterances:[self.stateSource expectedUserUtterances]];
}

- (void)witActivityDetectorStarted {

}

- (void)witDidStartRecording {
    [self.stateSource didStartProcessingUserInput];
    [self.stateSource didStartRecordingUserInput];
    NSLog(@"WitSpeechRecognitionService.witDidStartRecording: Recording startet");
    [GAIService logEventWithCategory:[GAICategories uIUsage] action:[GAIActions uIUsageWitInput] label:@"voice" value:0];
}

- (void)witDidStopRecording {
    [self.stateSource didStopRecordingUserInput];
    NSLog(@"WitSpeechRecognitionService.witDidStopRecording: Recording stopped");
}

- (void)interpretString:(NSString *)string {
    [self.stateSource didStartProcessingUserInput];
    [_wit interpretString:string customData:nil];
    [GAIService logEventWithCategory:[GAICategories uIUsage] action:[GAIActions uIUsageWitInput] label:@"text" value:0];
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

- (void)setState:(NSString *)state {
    NSLog(@"WitSpeechRecognitionService.setState: state is %@", state);
    _currState = state;
    [_wit setContext:@{@"state" : state}];
}

- (void)setThreadId:(NSString *)id {
    [_wit setThreadId:id];
}

- (void)logGAIEventWithAction:(NSString *)action label:(NSString *)label {
    [GAIService logEventWithCategory:[GAICategories witRecognize] action:action label:label value:0];
}

@end