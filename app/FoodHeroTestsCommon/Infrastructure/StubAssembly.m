//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "StubAssembly.h"
#import "RestaurantSearchServiceStub.h"
#import "RestaurantSearch.h"
#import "CLLocationManagerProxyStub.h"
#import "RandomizerStub.h"
#import "AlwaysImmediateSchedulerFactory.h"
#import "TextRepositoryStub.h"
#import "EnvironmentStub.h"
#import "SpeechRecognitionServiceStub.h"
#import "AudioSessionStub.h"
#import "FoodHero-Swift.h"


@implementation StubAssembly

- (id)restaurantSearchService {
    return [TyphoonDefinition withClass:[RestaurantSearchServiceStub class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)locationManagerProxy {
    return [TyphoonDefinition withClass:[CLLocationManagerProxyStub class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)randomizer {
    return [TyphoonDefinition withClass:[RandomizerStub class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)talkerRandomizer {
    return [TyphoonDefinition withClass:[TalkerRandomizerFake class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)schedulerFactory {
    return [TyphoonDefinition withClass:[AlwaysImmediateSchedulerFactory class]];
}

- (id)textRepository {
    return [TyphoonDefinition withClass:[TextRepositoryStub class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)environment {
    return [TyphoonDefinition withClass:[EnvironmentStub class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)speechRecognitionService {
    return [TyphoonDefinition withClass:[SpeechRecognitionServiceStub class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)audioSession {
    return [TyphoonDefinition withClass:[AudioSessionStub class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}


@end