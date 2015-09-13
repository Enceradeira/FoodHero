//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantReview.h"

@interface RestaurantRating : NSObject <NSCoding>
@property(readonly, nonatomic) double rating;
@property(readonly, nonatomic) NSArray *reviews;

+ (instancetype)createRating:(double)rating withReviews:(NSArray *)reviews;

- (id)initWithRating:(double)rating withReviews:(NSArray *)reviews;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToRating:(RestaurantRating *)rating;

- (NSUInteger)hash;

@end