//
// Created by Jorg on 16/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Wit.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "WitSpeechRecognitionService.h"
#import "SpeechInterpretation.h"
#import "NoSpeechInterpretationError.h"

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
        [_subscriber sendError:[NoSpeechInterpretationError create:error]];
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
        [_subscriber sendCompleted];
    }
    else {
        [_subscriber sendError:[NoSpeechInterpretationError create:nil]];
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

    id <ISchedulerFactory> _schedulerFactory;
    NSString *_accessToken;
    Wit *_configuredWit;
}

- (instancetype)initWithSchedulerFactory:(id <ISchedulerFactory>)schedulerFactory accessToken:(NSString *)accessToken {
    self = [super init];
    if (self) {
        _schedulerFactory = schedulerFactory;
        _accessToken = accessToken;

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

- (RACSignal *)interpretString:(NSString *)string state:(NSString *)state {
    RACSignal *signal = [[RACSignal startEagerlyWithScheduler:_schedulerFactory.asynchScheduler block:^(id <RACSubscriber> subscriber) {
        [self setContext:state subscriber:subscriber];

        [self.wit interpretString:string customData:state];
    }] deliverOn:[_schedulerFactory mainThreadScheduler]];

    return signal;
}

- (RACSignal *)recordAndInterpretUserVoice:(NSString *)state {
    RACSignal *signal = [RACSignal startEagerlyWithScheduler:_schedulerFactory.mainThreadScheduler block:^(id <RACSubscriber> subscriber) {
        [self setContext:state subscriber:subscriber];
        [self.wit start];
    }];

    return signal;
}


@end