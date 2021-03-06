//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@protocol ApplicationAssembly

- (id)restaurantDetailViewController;

- (id)restaurantDetailTableViewController;

- (id)restaurantPhotoViewController;

- (id)restaurantReviewSummaryViewController;

- (id)restaurantMapViewController;

- (id)navigationViewController;

- (id)conversationViewController;

- (id)suggestionLikedController;

- (id)speechRecognitionService;

- (id)conversationAppService;

- (id)conversationRepository;

- (id)restaurantSearch;

- (id)restaurantSearchService;

- (id)locationService;

- (id)locationManagerProxy;

- (id)talkerRandomizer;

- (id)restaurantRepository;

- (id)schedulerFactory;

- (id)environment;

- (id)audioSession;

-(id)geocoderService;

-(id)placesAPI;

-(id)uiApplication;

- (id)feedbackNotificationEventManager;
@end
