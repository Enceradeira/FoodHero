//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RestaurantReview : NSObject <NSCoding>

@property(nonatomic, readonly) NSString *text;
@property(nonatomic, readonly) double rating;
@property(nonatomic, readonly) NSString *author;
@property(nonatomic, readonly) NSDate *date;

+ (instancetype)create:(NSString *)review rating:(double)rating author:(NSString *)author date:(NSDate *)date;

- (id)init:(NSString *)review rating:(double)rating author:(NSString *)author date:(NSDate *)date;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToReview:(RestaurantReview *)review;

- (NSUInteger)hash;
@end