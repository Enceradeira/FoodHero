//
// Created by Jorg on 21/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


extern const double DISTANCE_DECREMENT_FACTOR;

@interface DistanceRange : NSObject

@property(nonatomic, readonly) double max;

+ (instancetype)distanceRangeNearerThan:(double)distance;

+ (instancetype)distanceRangeWithoutRestriction;
@end