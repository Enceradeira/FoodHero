//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReview.h"


@implementation RestaurantReview {

}
+ (instancetype)create:(NSString *)review rating:(double)rating author:(NSString *)author date:(NSDate *)date {
    return [[RestaurantReview alloc] init:review rating:rating author:author date:date];
}

- (id)init:(NSString *)review rating:(double)rating author:(NSString *)author date:(NSDate *)date {
    self = [super init];
    if (self) {
        _text = review;
        _rating = rating;
        _author = author;
        _date = date;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _text = [coder decodeObjectForKey:@"_text"];
        _rating = [coder decodeDoubleForKey:@"_rating"];
        _author = [coder decodeObjectForKey:@"_author"];
        _date = [coder decodeObjectForKey:@"_date"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.text forKey:@"_text"];
    [coder encodeDouble:self.rating forKey:@"_rating"];
    [coder encodeObject:self.author forKey:@"_author"];
    [coder encodeObject:self.date forKey:@"_date"];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToReview:other];
}

- (BOOL)isEqualToReview:(RestaurantReview *)review {
    if (self == review)
        return YES;
    if (review == nil)
        return NO;
    if (self.text != review.text && ![self.text isEqualToString:review.text])
        return NO;
    if (self.rating != review.rating)
        return NO;
    if (self.author != review.author && ![self.author isEqualToString:review.author])
        return NO;
    if (self.date != review.date && ![self.date isEqualToDate:review.date])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.text hash];
    hash = hash * 31u + [[NSNumber numberWithDouble:self.rating] hash];
    hash = hash * 31u + [self.author hash];
    hash = hash * 31u + [self.date hash];
    return hash;
}


@end