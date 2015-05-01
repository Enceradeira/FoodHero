//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantSearch.h"
#import "Restaurant.h"
#import "ConversationSourceStub.h"
#import "FoodHero-Swift.h"

@class RestaurantSearchResult;


@interface RestaurantSearchTests : XCTestCase
@property(nonatomic, readonly) ConversationSourceStub *conversation;

- (RestaurantSearch *)search;

- (RestaurantSearchResult *)findBest;

- (void)conversationHasCuisine:(NSString *)cuisine;

- (void)conversationHasPriceRange:(PriceRange *)range;

- (void)conversationHasNegativeUserFeedback:(USuggestionFeedbackParameters *)feedback;

- (void)conversationHasSuggestedRestaurant:(Restaurant *)restaurant;

- (void)conversationStartsNewSearch;
@end