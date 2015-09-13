//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRating.h"


@implementation RestaurantRating {

}
+ (instancetype)createRating:(double)rating withReviews:(NSArray *)reviews {
    return [[RestaurantRating alloc] initWithRating:rating withReviews:reviews];
}

- (id)initWithRating:(double)rating withReviews:(NSArray *)reviews {
    self = [super init];
    if (self) {

        NSArray *cleanReviews = [reviews linq_where:^(RestaurantReview *r) {
            return (BOOL) (r.text != nil && ![r.text isEqualToString:@""]);
        }];

        _rating = rating;
        _reviews = cleanReviews;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _rating = [coder decodeDoubleForKey:@"_rating"];
        _reviews = [coder decodeObjectForKey:@"_reviews"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeDouble:self.rating forKey:@"_rating"];
    [coder encodeObject:self.reviews forKey:@"_reviews"];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToRating:other];
}

- (BOOL)isEqualToRating:(RestaurantRating *)rating {
    if (self == rating)
        return YES;
    if (rating == nil)
        return NO;
    if (self.rating != rating.rating)
        return NO;
    if (self.reviews != rating.reviews && ![self.reviews isEqualToArray:rating.reviews])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [[NSNumber numberWithDouble:self.rating] hash];
    hash = hash * 31u + [self.reviews hash];
    return hash;
}


@end