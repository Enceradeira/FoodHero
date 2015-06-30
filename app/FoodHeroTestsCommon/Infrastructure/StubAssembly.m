//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "StubAssembly.h"
#import "RestaurantSearchServiceStub.h"
#import "RestaurantSearch.h"
#import "CLLocationManagerProxyStub.h"
#import "AlwaysImmediateSchedulerFactory.h"
#import "EnvironmentStub.h"
#import "SpeechRecognitionServiceStub.h"
#import "AudioSessionStub.h"
#import "FoodHero-Swift.h"
#import "GoogleRestaurantSearch.h"
#import "Environment.h"
#import "DefaultSchedulerFactory.h"
#import "RestaurantRepository.h"
#import "CLLocationManagerImpl.h"
#import "WitSpeechRecognitionService.h"
#import "AudioSession.h"
#import "ConversationAppService.h"
#import "NavigationController.h"
#import "RestaurantDetailViewController.h"
#import "ConversationViewController.h"
#import "RestaurantDetailTableViewController.h"
#import "RestaurantPhotoViewController.h"
#import "RestaurantReviewSummaryViewController.h"

@implementation StubAssembly

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

-(id)suggestionLikedController{
    return [TyphoonDefinition
            withClass:[SuggestionLikedController class] configuration:^(TyphoonDefinition *definition) {
                [definition injectMethod:@selector(setEnvironment:) parameters:^(TyphoonMethod *method) {
                    [method injectParameterWith:[self environment]];

                }];
            }
    ];
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
                              [definition useInitializer:@selector(initWithRestaurantRepository:locationService:schedulerFactory:geocoderService:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self restaurantRepository]];
                                  [method injectParameterWith:[self locationService]];
                                  [method injectParameterWith:[self schedulerFactory]];
                                  [method injectParameterWith:[self geocoderService]];
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

- (id)restaurantRepository {
    return [TyphoonDefinition withClass:[RestaurantRepository class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithSearchService:schedulerFactory:) parameters:^(TyphoonMethod *method) {
                                  [method injectParameterWith:[self restaurantSearchService]];
                                  [method injectParameterWith:[self schedulerFactory]];
                              }];
                              definition.scope = TyphoonScopeSingleton; // Because it holds state
                          }];
}

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

- (id)talkerRandomizer {
    return [TyphoonDefinition withClass:[TalkerRandomizerFake class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)schedulerFactory {
    return [TyphoonDefinition withClass:[AlwaysImmediateSchedulerFactory class]];
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

- (id)geocoderService {
    [[GeocoderServiceStub alloc] init];
    return [TyphoonDefinition withClass:[GeocoderServiceStub class]];
}


@end