//
//  JENAppAssembly.m
//  HelloWorldApp
//
//  Created by Jorg on 10/06/2014.
//  Copyright (c) 2014 co.uk.jennius. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "DefaultAssembly.h"
#import "NavigationController.h"
#import "ConversationViewController.h"
#import "GoogleRestaurantSearch.h"
#import "RestaurantSearch.h"
#import "CLLocationManagerImpl.h"
#import "DefaultTokenRandomizer.h"
#import "CuisineTableViewController.h"
#import "FeedbackTableViewController.h"
#import "WhatToDoNextTableViewController.h"
#import "ProblemWithAccessLocationServiceResolvedTableViewController.h"
#import "RestaurantRepository.h"
#import "TryAgainTableViewController.h"

@implementation DefaultAssembly
- (id)navigationViewController {
    return [TyphoonDefinition withClass:[NavigationController class]];
}

- (id)problemWithAccessLocationServiceResolvedTableViewController {
    return [TyphoonDefinition withClass:[ProblemWithAccessLocationServiceResolvedTableViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setAppService:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self conversationAppService]];

        }];
    }];
}

- (id)feedbackTableViewController {
    return [TyphoonDefinition withClass:[FeedbackTableViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setAppService:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self conversationAppService]];

        }];
    }];
}

- (id)whatToDoNextTableViewController {
    return [TyphoonDefinition withClass:[WhatToDoNextTableViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setAppService:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self conversationAppService]];

        }];
    }];
}

- (id)tryAgainTableViewController {
    return [TyphoonDefinition withClass:[TryAgainTableViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setAppService:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self conversationAppService]];

        }];
    }];
}

- (id)cuisineTableViewController {
    return [TyphoonDefinition withClass:[CuisineTableViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setConversationAppService:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self conversationAppService]];

        }];
    }];
}

- (id)conversationViewController {
    return [TyphoonDefinition
            withClass:[ConversationViewController class] configuration:^(TyphoonDefinition *definition) {
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
            [definition useInitializer:@selector(initWithConversationRepository:restaurantRepository:locationService:) parameters:^(TyphoonMethod *method) {
                [method injectParameterWith:[self conversationRepository]];
                [method injectParameterWith:[self restaurantRepository]];
                [method injectParameterWith:[self locationService]];
            }];
            definition.scope = TyphoonScopeSingleton; // Because it holds state
        }
    ];
}

- (id)conversationRepository {
    return [TyphoonDefinition withClass:[ConversationRepository class]];
}

- (id)restaurantSearch {
    return [TyphoonDefinition withClass:[RestaurantSearch class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithRestaurantRepository:locationService:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self restaurantRepository]];
                                  [method injectParameterWith:[self locationService]];

                              }];
                          }];
}

- (id)locationService {
    return [TyphoonDefinition withClass:[LocationService class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithLocationManager:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self locationManagerProxy]];

                              }];
                              definition.scope = TyphoonScopeSingleton; // Because it holds state
                          }];
}

- (id)locationManagerProxy {
    return [TyphoonDefinition withClass:[CLLocationManagerImpl class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithLocationManager:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[CLLocationManager new]];

                              }];
                          }];
}

- (id)tokenRandomizer {
    return [TyphoonDefinition withClass:[DefaultTokenRandomizer class]];;
}

- (id)restaurantRepository {
    return [TyphoonDefinition withClass:[RestaurantRepository class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithSearchService:locationService:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self restaurantSearchService]];
                                  [method injectParameterWith:[self locationService]];
                              }];
                              definition.scope = TyphoonScopeSingleton; // Because it holds state
                          }];
}


- (id)restaurantSearchService {
    return [TyphoonDefinition withClass:[GoogleRestaurantSearch class]];
}

- (id)conversation {
    return [TyphoonDefinition withClass:[Conversation class]];
}
@end
