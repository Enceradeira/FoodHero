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
}

- (instancetype)initWithSchedulerFactory:(id <ISchedulerFactory>)schedulerFactory accessToken:(NSString *)accessToken {
    self = [super init];
    if (self) {
        _schedulerFactory = schedulerFactory;
        _accessToken = accessToken;
    }

    return self;
}

- (RACSignal *)interpretString:(NSString *)string customData:(id)customData {
    RACSignal *signal = [[RACSignal startEagerlyWithScheduler:_schedulerFactory.asynchScheduler block:^(id <RACSubscriber> subscriber) {
        Wit *wit = [[Wit alloc] init];
        wit.accessToken = _accessToken;
        //enabling detectSpeechStop will automatically stop listening the microphone when the user stop talking
        wit.detectSpeechStop = WITVadConfigDetectSpeechStop;
        wit.delegate = [WitDelegate create:subscriber];
        [wit interpretString:string customData:customData];
    }] deliverOn:[_schedulerFactory mainThreadScheduler]];

    return signal;
}


@end