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
#import "SoundPlayerFake.h"


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

- (id)schedulerFactory {
    return [TyphoonDefinition withClass:[AlwaysImmediateSchedulerFactory class]];
}

- (id)textRepository {
    return [TyphoonDefinition withClass:[TextRepositoryStub class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)soundPlayer {
    return [TyphoonDefinition withClass:[SoundPlayerFake class]];
}


@end