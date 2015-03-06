//
// Created by Jorg on 16/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Wit.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "WitSpeechRecognitionService.h"
#import "SpeechInterpretation.h"

@interface WitDelegate : NSObject <WitDelegate>
+ (id <WitDelegate>)create:(id <RACSubscriber>)subscriber;

- (id)init:(id <RACSubscriber>)subscriber;
@end

@implementation WitDelegate {

    id <RACSubscriber> _subscriber;
}
- (void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id)customData error:(NSError *)error {
    SpeechInterpretation *interpretation = [SpeechInterpretation new];
    if (error) {
        assert(false); // TODO error-handling
    }
    if (outcomes.count > 0) {
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
        [_subscriber sendNext:interpretation];
    }
    else {
        assert(false); // TODO error-handling
    }
}

- (void)witActivityDetectorStarted {

}

- (void)witDidStartRecording {
    NSLog(@"Recording startet");
}

- (void)witDidStopRecording {
    NSLog(@"Recording stopped");
}


- (id)init:(id <RACSubscriber>)subscriber {
    self = [super init];
    if (self) {
        _subscriber = subscriber;
    }
    return self;
}

+ (instancetype)create:(id <RACSubscriber>)subscriber {
    return [[WitDelegate alloc] init:subscriber];
}

@end

@implementation WitSpeechRecognitionService {

    NSString *_accessToken;
    Wit *_configuredWit;
    id <IAudioSession> _audioSession;
    RACSubject *_output;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken audioSession:(id <IAudioSession>)audioSession {
    self = [super init];
    if (self) {
        _accessToken = accessToken;
        _audioSession = audioSession;
        _output = [RACSubject new];
    }

    return self;
}

- (void)setContext:(NSString *)state subscriber:(id <RACSubscriber>)subscriber {
    [self.wit setContext:@{@"state" : state}];
    self.wit.delegate = [WitDelegate create:subscriber];
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


@end