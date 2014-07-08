//
//  JENAppAssembly.m
//  HelloWorldApp
//
//  Created by Jorg on 10/06/2014.
//  Copyright (c) 2014 co.uk.jennius. All rights reserved.
//

#import "DefaultAssembly.h"
#import "NavigationController.h"
#import "ConversationViewController.h"
#import "GoogleRestaurantSearch.h"
#import "RestaurantSearch.h"

@implementation DefaultAssembly
- (id)navigationViewController {
    return [TyphoonDefinition withClass:[NavigationController class]];
}

- (id)conversationViewController {
    return [TyphoonDefinition
            withClass:[ConversationViewController class]
        configuration:^(TyphoonDefinition *definition) {
                [definition injectMethod:@selector(setConversationAppService:) parameters:^(TyphoonMethod *method) {
                    [method injectParameterWith:[self conversationAppService]];

                }];
            }
    ];
}

- (id)conversationAppService {
    return [TyphoonDefinition
            withClass:[ConversationAppService class]
        configuration:^(TyphoonDefinition *definition) {
                [definition useInitializer:@selector(initWithDependencies:) parameters:^(TyphoonMethod *method) {
                    [method injectParameterWith:[self conversationRepository]];

                }];
            }
    ];
}

- (id)conversationRepository {
    return [TyphoonDefinition withClass:[ConversationRepository class]];
}

- (id)restaurantSearch {
    return [TyphoonDefinition withClass:[RestaurantSearch class]
                          configuration:^(TyphoonDefinition *definition) {
                [definition useInitializer:@selector(initWithDependencies:) parameters:^(TyphoonMethod *method) {
                    [method injectParameterWith:[self restaurantSearchService]];

                }];
            }];
}

- (id)restaurantSearchService {
    return [TyphoonDefinition withClass:[GoogleRestaurantSearch class]];
}

- (id)conversation {
    return [TyphoonDefinition
            withClass:[Conversation class]
        configuration:^(TyphoonDefinition *definition) {
                [definition useInitializer:@selector(initWithDependencies:) parameters:^(TyphoonMethod *method) {
                    [method injectParameterWith:[self restaurantSearch]];

                }];
            }
    ];
}
@end
