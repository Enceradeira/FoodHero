//
// Created by Jorg on 02/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantRatingBuilder.h"
#import "RestaurantReviewBuilder.h"


@implementation RestaurantRatingBuilder {

    double _rating;
    NSArray *_reviews;
}
- (RestaurantRating *)build {
    double rating = _rating == 0 ? 3.2 : _rating;
    NSArray *reviews = _reviews == nil ? [self defaultReviews] : _reviews;
    return [RestaurantRating createRating:rating withReviews:reviews];
}

- (NSArray *)defaultReviews {
    return @[
            [[[RestaurantReviewBuilder alloc] withText:@"Expensive place at superb location"] build],
            [[[RestaurantReviewBuilder alloc] withText:@"The slug was terribly overcook and disgusting"] build],
            [[[RestaurantReviewBuilder alloc] withText:@"I always like going there since 23 years"] build]
    ];
}

- (RestaurantRatingBuilder *)withRating:(double)rating {
    _rating = rating;
    return self;
}

- (RestaurantRatingBuilder *)withReviews:(NSArray *)reviews {
    _reviews = reviews;
    return self;
}


@end