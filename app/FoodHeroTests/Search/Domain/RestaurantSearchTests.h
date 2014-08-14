//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Restaurant;
@class USuggestionFeedbackForNotLikingAtAll;
@class RestaurantSearch;


@interface RestaurantSearchTests : XCTestCase
- (RestaurantSearch *)search;

- (Restaurant *)findBest;

- (void)feedbackIs:(USuggestionFeedbackForNotLikingAtAll *)feedback;
@end