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
#import "DefaultRandomizer.h"
#import "DefaultSchedulerFactory.h"
#import "TextRepository.h"
#import "SoundPlayer.h"
#import "RestaurantDetailViewController.h"
#import "Environment.h"
#import "WitSpeechRecognitionService.h"
#import "NullInputViewController.h"

@implementation DefaultAssembly
- (id)navigationViewController {
    return [TyphoonDefinition withClass:[NavigationController class]];
}

- (id)restaurantDetailViewController {
    return [TyphoonDefinition withClass:[RestaurantDetailViewController class]];
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

- (id)speechRecognitionService {
    return [TyphoonDefinition withClass:[WitSpeechRecognitionService class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithSchedulerFactory:accessToken:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self schedulerFactory]];
                                  [method injectParameterWith:@"DD2C4J3PUPYIB54FU4RTENECFZN7GXZ2"]; // Instance "FoodHero"
                              }];
                          }];
}

- (id)conversationAppService {
    return [TyphoonDefinition
            withClass:[ConversationAppService class]
        configuration:^(TyphoonDefinition *definition) {
            [definition useInitializer:@selector(initWithConversationRepository:restaurantRepository:locationService:speechRegocnitionService:) parameters:^(TyphoonMethod *method) {
                [method injectParameterWith:[self conversationRepository]];
                [method injectParameterWith:[self restaurantRepository]];
                [method injectParameterWith:[self locationService]];
                [method injectParameterWith:[self speechRecognitionService]];
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
                              [definition useInitializer:@selector(initWithRestaurantRepository:locationService:schedulerFactory:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self restaurantRepository]];
                                  [method injectParameterWith:[self locationService]];
                                  [method injectParameterWith:[self schedulerFactory]];

                              }];
                          }];
}

- (id)locationService {
    return [TyphoonDefinition withClass:[LocationService class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithLocationManager:schedulerFactory:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self locationManagerProxy]];
                                  [method injectParameterWith:[self schedulerFactory]];

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

- (id)randomizer {
    return [TyphoonDefinition withClass:[DefaultRandomizer class]];;
}

- (id)restaurantRepository {
    return [TyphoonDefinition withClass:[RestaurantRepository class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithSearchService:locationService:schedulerFactory:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self restaurantSearchService]];
                                  [method injectParameterWith:[self locationService]];
                                  [method injectParameterWith:[self schedulerFactory]];
                              }];
                              definition.scope = TyphoonScopeSingleton; // Because it holds state
                          }];
}

- (id)schedulerFactory {
    return [TyphoonDefinition withClass:[DefaultSchedulerFactory class]];
}

- (id)textRepository {
    return [TyphoonDefinition withClass:[TextRepository class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithRandomizer:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self randomizer]];

                              }];
                          }];
}

- (id)soundPlayer {
    return [TyphoonDefinition withClass:[SoundPlayer class]];
}

- (id)environment {
    return [TyphoonDefinition withClass:[Environment class]];
}

- (id)nullUserInputController {
    return [TyphoonDefinition withClass:[NullInputViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectMethod:@selector(setConversationAppService:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self conversationAppService]];

                              }];
                          }];
}


- (id)restaurantSearchService {
    return [TyphoonDefinition withClass:[GoogleRestaurantSearch class]];
}

- (id)conversation {
    return [TyphoonDefinition withClass:[Conversation class]];
}
@end
