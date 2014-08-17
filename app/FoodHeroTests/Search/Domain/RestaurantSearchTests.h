//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantSearch.h"
#import "Restaurant.h"
#import "ConversationToken.h"
#import "USuggestionNegativeFeedback.h"


@interface RestaurantSearchTests : XCTestCase
- (RestaurantSearch *)search;

- (Restaurant *)findBest;

- (void)conversationHasCuisine:(NSString *)cuisine;

- (void)conversationHasPriceRange:(PriceLevelRange *)range;

- (void)conversationHasNegativeUserFeedback:(USuggestionNegativeFeedback *)feedback;
@end