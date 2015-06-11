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
    int _engagementCount;
    NSDate *_startTimeWit;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken audioSession:(id <IAudioSession>)audioSession {
    self = [super init];
    if (self) {
        _accessToken = accessToken;
        _audioSession = audioSession;
        _output = [RACSubject new];
        _simulateNetworkError = NO;
        _engagementCount = 0;

        _wit = [Wit sharedInstance];
        _wit.accessToken = _accessToken;
        _wit.detectSpeechStop = WITVadConfigDetectSpeechStop;
        _wit.delegate = self;
    }

    return self;
}

- (void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id)customData error:(NSError *)error {
    NSTimeInterval timeElapsed = [_startTimeWit timeIntervalSinceNow];
    [GAIService logTimingWithCategory:[GAICategories externalCallTimings] name:[GAITimingNames wit] label:@"" interval:timeElapsed];

    SpeechInterpretation *interpretation = [SpeechInterpretation new];
    if (error != nil || _simulateNetworkError) {
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] || _simulateNetworkError) {
            id value = [NetworkError new];
            [_output sendNext:value];
            [self logGAINegativeExperience:@"NSURLErrorDomain"];

        }
        else {
            NSLog(@"WitDelegate detected unexptected error '%@'. It will handle it as UserIntentUnclearError", [error domain]);
            [_output sendNext:[self userIntentUnclearError]];
            [self logGAINegativeExperience:@"WitUnexpectedError"];
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
            [_output sendNext:[self userIntentUnclearError]];
            [self logGAINegativeExperience:@"WitLowConfidence"];
        }
        else {
            [_output sendNext:interpretation];
            // [GAIService logEventWithCategory:[GAICategories witRecognize] action:interpretation.intent label:@"" value:0];
        }
    }
    else {
        [_output sendNext:[self userIntentUnclearError]];
        [self logGAINegativeExperience:@"WitNoOutcome"];
    }
    [self.stateSource didStopProcessingUserInput];
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
    [self logGAIEventUiUsage:@"voice"];
    [self logGAIEventEngagement];
}

- (void)witDidStopRecording {
    [self.stateSource didStopRecordingUserInput];
    [self startWitTimer];
    NSLog(@"WitSpeechRecognitionService.witDidStopRecording: Recording stopped");
}

- (void)interpretString:(NSString *)string {
    [self.stateSource didStartProcessingUserInput];
    [_wit interpretString:string customData:nil];
    [self startWitTimer];
    [self logGAIEventUiUsage:@"text"];
    [self logGAIEventEngagement];
}

- (void)startWitTimer {
    _startTimeWit = [NSDate date];
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

- (void)logGAIEventEngagement {
    _engagementCount++;
    NSString *label = [NSString stringWithFormat:@"%i", _engagementCount];
    [GAIService logEventWithCategory:[GAICategories engagement] action:[GAIActions engagementConversation] label:label value:0];
}

- (void)logGAIEventUiUsage:(NSString *)label {
    [GAIService logEventWithCategory:[GAICategories uIUsage] action:[GAIActions uIUsageWitInput] label:label value:0];
}


- (void)logGAINegativeExperience:(NSString *)label {
    [GAIService logEventWithCategory:[GAICategories negativeExperience] action:[GAIActions negativeExperienceError] label:label value:0];
}
 
@end