//
// Created by Jorg on 16/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

const extern NSUInteger GOOGLE_PRICE_LEVEL_MIN;
const extern NSUInteger GOOGLE_PRICE_LEVEL_MAX;


@interface PriceRange : NSObject <NSCoding>
@property(nonatomic, readonly) NSUInteger min;
@property(nonatomic, readonly) NSUInteger max;

+ (instancetype)priceRangeWithoutRestriction;

- (instancetype)initWithMin:(NSUInteger)min max:(NSUInteger)max;

- (PriceRange *)setMaxLowerThan:(NSUInteger)value;

- (PriceRange *)setMinHigherThan:(NSUInteger)value;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

@end