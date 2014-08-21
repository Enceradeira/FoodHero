//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantSearch.h"
#import "Restaurant.h"
#import "ConversationToken.h"
#import "USuggestionNegativeFeedback.h"
#import "ConversationSourceStub.h"


@interface RestaurantSearchTests : XCTestCase
@property(nonatomic, readonly) ConversationSourceStub *conversation;

- (RestaurantSearch *)search;

- (Restaurant *)findBest;

- (void)conversationHasCuisine:(NSString *)cuisine;

- (void)conversationHasPriceRange:(PriceRange *)range;

- (void)conversationHasNegativeUserFeedback:(USuggestionNegativeFeedback *)feedback;
@end