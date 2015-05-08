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
#import "DefaultSchedulerFactory.h"
#import "RestaurantDetailViewController.h"
#import "Environment.h"
#import "WITRecordingSession.h"
#import "WitSpeechRecognitionService.h"
#import "AudioSession.h"
#import "FoodHero-Swift.h"
#import "RestaurantDetailTableViewController.h"
#import "RestaurantPhotoViewController.h"
#import "RestaurantReviewSummaryViewController.h"
#import "RestaurantRepository.h"

@implementation DefaultAssembly
- (id)navigationViewController {
    return [TyphoonDefinition withClass:[NavigationController class]];
}

- (id)restaurantDetailViewController {
    return [TyphoonDefinition withClass:[RestaurantDetailViewController class]];
}

- (id)restaurantDetailTableViewController {
    return [TyphoonDefinition
            withClass:[RestaurantDetailTableViewController class] configuration:^(TyphoonDefinition *definition) {
                [definition injectMethod:@selector(setLocationService:) parameters:^(TyphoonMethod *method) {
                    [method injectParameterWith:[self locationService]];

                }];
            }
    ];
}

-(id)restaurantPhotoViewController{
    return [TyphoonDefinition
            withClass:[RestaurantPhotoViewController class] configuration:^(TyphoonDefinition *definition) {
                [definition injectMethod:@selector(setSchedulerFactory:) parameters:^(TyphoonMethod *method) {
                    [method injectParameterWith:[self schedulerFactory]];

                }];
            }
    ];
}

-(id)restaurantReviewSummaryViewController{
    return [TyphoonDefinition
            withClass:[RestaurantReviewSummaryViewController class] configuration:^(TyphoonDefinition *definition) {
                [definition injectMethod:@selector(setSchedulerFactory:) parameters:^(TyphoonMethod *method) {
                    [method injectParameterWith:[self schedulerFactory]];

                }];
            }
    ];
}

-(id)restaurantMapViewController{
    return [TyphoonDefinition
            withClass:[RestaurantMapViewController class] configuration:^(TyphoonDefinition *definition) {
                [definition injectMethod:@selector(setLocationService:) parameters:^(TyphoonMethod *method) {
                    [method injectParameterWith:[self locationService]];

                }];
            }
    ];
}

- (id)conversationViewController {
    return [TyphoonDefinition
            withClass:[ConversationViewController class] configuration:^(TyphoonDefinition *definition) {
                [definition injectMethod:@selector(setConversationAppService:) parameters:^(TyphoonMethod *method) {
                    [method injectParameterWith:[self conversationAppService]];

                }];
                definition.scope = TyphoonScopeSingleton; // Because it holds state
            }
    ];
}

- (id)speechRecognitionService {
    return [TyphoonDefinition withClass:[WitSpeechRecognitionService class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithAccessToken:audioSession:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:@"E2DAN6OIJ62CURVSFO6VRPU7E4DBIAZG"]; // Instance "FoodHero-Prod"
                                  // FoodHero-Test [method injectParameterWith:@"IEOCNANTTA2ZMX7R53QCB3WWTGA6U5XC"]; // Instance "FoodHero"
                                  [method injectParameterWith:[self audioSession]];
                              }];
                              definition.scope = TyphoonScopeSingleton; // Because it holds state
                          }];
}

- (id)audioSession {
    return [TyphoonDefinition withClass:[AudioSession class]];
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
    return [TyphoonDefinition withClass:[ConversationRepository class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithAssembly:) parameters:^
                              (TyphoonMethod *method) {
                                  [method injectParameterWith:self];

                              }];
                              definition.scope = TyphoonScopeSingleton; // Because it holds state
                          }];
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

- (id)talkerRandomizer {
    return [TyphoonDefinition withClass:[TalkerRandomizer class]];;
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

- (id)environment {
    return [TyphoonDefinition withClass:[Environment class]];
}

- (id)restaurantSearchService {
    return [TyphoonDefinition withClass:[GoogleRestaurantSearch class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithEnvironment:onlyOpenNow:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self environment]];
                                  [method injectParameterWith:@(YES)];
                              }];
                          }];
}

@end
