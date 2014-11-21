//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@protocol ApplicationAssembly

- (id)restaurantDetailViewController;

- (id)navigationViewController;

- (id)conversationViewController;

-(id)speechRecognitionService;

- (id)conversationAppService;

- (id)conversationRepository;

- (id)restaurantSearch;

- (id)restaurantSearchService;

- (id)conversation;

- (id)locationService;

- (id)locationManagerProxy;

- (id)randomizer;

- (id)restaurantRepository;

- (id)schedulerFactory;

- (id)textRepository;

- (id)soundPlayer;

- (id)environment;

- (id)nullUserInputController;
@end
