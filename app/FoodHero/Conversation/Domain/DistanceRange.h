//
// Created by Jorg on 21/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


extern const double DISTANCE_DECREMENT_FACTOR;
extern const double MAX_NORMAL_DISTANCE;
extern const double SCORE_AT_MAX_DISTANCE_RANGE;

@interface DistanceRange : NSObject <NSCoding>

@property(nonatomic, readonly) double max;

+ (instancetype)distanceRangeNearerThan:(double)distance;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToRange:(DistanceRange *)range;

- (NSUInteger)hash;

@end