//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@protocol ApplicationAssembly
- (id)whatToDoNextTableViewController;

- (id)feedbackTableViewController;

- (id)cuisineTableViewController;

- (id)navigationViewController;

- (id)conversationViewController;

- (id)conversationAppService;

- (id)conversationRepository;

- (id)restaurantSearch;

- (id)restaurantSearchService;

- (id)conversation;

- (id)locationService;

- (id)locationManagerProxy;

- (id)tokenRandomizer;

@end
