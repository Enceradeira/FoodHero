//
// Created by Jorg on 16/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

const extern NSUInteger GOOGLE_PRICE_LEVEL_MIN;
const extern NSUInteger GOOGLE_PRICE_LEVEL_MAX;


@interface PriceLevelRange : NSObject
@property(nonatomic, readonly) NSUInteger min;
@property(nonatomic, readonly) NSUInteger max;

+ (instancetype)createFullRange;

- (instancetype)initWithMin:(NSUInteger)min max:(NSUInteger)max;

- (PriceLevelRange *)setMaxLowerThan:(NSUInteger)value;

- (PriceLevelRange *)setMinHigherThan:(NSUInteger)value;

@end