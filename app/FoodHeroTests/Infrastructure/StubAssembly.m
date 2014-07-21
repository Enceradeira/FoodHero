//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "StubAssembly.h"
#import "RestaurantSearchServiceStub.h"
#import "RestaurantSearch.h"
#import "CLLocationManagerProxyStub.h"
#import "AlternationRandomizerStub.h"


@implementation StubAssembly

- (id)restaurantSearchService {
    return [TyphoonDefinition withClass:[RestaurantSearchServiceStub class] configuration:^(TyphoonDefinition *definition)
            {
                definition.scope = TyphoonScopeSingleton;
            }];
}

- (id)locationManagerProxy {
    return [TyphoonDefinition withClass:[CLLocationManagerProxyStub class] configuration:^(TyphoonDefinition *definition)
            {
                definition.scope = TyphoonScopeSingleton;
            }];
}

- (id)alternationRandomizer {
    return [TyphoonDefinition withClass:[AlternationRandomizerStub class] configuration:^(TyphoonDefinition *definition)
            {
                definition.scope = TyphoonScopeSingleton;
            }];
}


@end