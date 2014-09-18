//
// Created by Jorg on 18/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "IntegrationAssembly.h"
#import "RandomizerStub.h"


@implementation IntegrationAssembly {

}

- (id)randomizer {
    return [TyphoonDefinition withClass:[RandomizerStub class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

@end