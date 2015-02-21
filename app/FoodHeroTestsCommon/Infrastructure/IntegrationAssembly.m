//
// Created by Jorg on 18/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "IntegrationAssembly.h"
#import "RandomizerStub.h"
#import "WitSpeechRecognitionService.h"
#import "CLLocationManagerProxyStub.h"
#import "AudioSessionStub.h"


@implementation IntegrationAssembly {

}

- (id)randomizer {
    return [TyphoonDefinition withClass:[RandomizerStub class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)speechRecognitionService {
    return [TyphoonDefinition withClass:[WitSpeechRecognitionService class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithAccessToken:audioSession:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self schedulerFactory]];
                                  [method injectParameterWith:@"IEOCNANTTA2ZMX7R53QCB3WWTGA6U5XC"]; // Instance "FoodHero-Test"
                                  [method injectParameterWith:[self audioSession]];
                              }];
                          }];
}

- (id)locationManagerProxy {
    return [TyphoonDefinition withClass:[CLLocationManagerProxyStub class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)audioSession {
    return [TyphoonDefinition withClass:[AudioSessionStub class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}


@end