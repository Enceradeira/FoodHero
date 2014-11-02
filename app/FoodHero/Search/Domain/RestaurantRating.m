//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRating.h"


@implementation RestaurantRating {

}
+ (instancetype)createRating:(double)rating withReviews:(NSArray *)reviews {
    return [[RestaurantRating alloc] initRating:rating withReviews:reviews];
}

- (id)initRating:(double)rating withReviews:(NSArray *)reviews {
    self = [super init];
    if (self) {
        _rating = rating;
        if (reviews.count > 0) {
            _summary = reviews[0];
        }
        _reviews = [reviews linq_skip:1];
    }
    return self;
}

@end