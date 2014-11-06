//
// Created by Jorg on 02/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantRating.h"

@interface RestaurantRatingBuilder : NSObject
- (RestaurantRating *)build;

- (RestaurantRatingBuilder *)withRating:(double)rating;

- (RestaurantRatingBuilder *)withReviews:(NSArray *)reviews;
@end