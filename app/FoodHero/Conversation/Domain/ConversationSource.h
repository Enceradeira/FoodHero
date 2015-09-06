//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PriceRange.h"
#import "SearchProfile.h"

@class ConversationParameters;

@protocol ConversationSource <NSObject>

- (NSArray *)negativeUserFeedback;

- (NSArray *)dislikedRestaurants;

- (SearchProfile *)currentSearchPreference:(double)maxDistancePlaces searchLocation:(CLLocation *)location;

- (ConversationParameters *)lastSuggestionWarning;

- (NSArray *)suggestedRestaurantsInCurrentSearch;

- (NSString *)currentSearchLocation;
@end