//
// Created by Jorg on 21/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "DistanceRange.h"
#import "DesignByContractException.h"


const double DISTANCE_DECREMENT_FACTOR = 0.66666;
const double MAX_NORMAL_DISTANCE = 1;
const double SCORE_AT_MAX_DISTANCE_RANGE = 0.2;

@implementation DistanceRange {

}

- (instancetype)initWithMax:(double)max {
    self = [super init];
    if (self) {
        if (max < 0) {
            @throw [DesignByContractException createWithReason:@"maxDistance can't be less than 0"];
        }
        if (max > 1) {
            @throw [DesignByContractException createWithReason:@"maxDistance can't be greater than 1"];
        }
        _max = max;
    }
    return self;
}


+ (instancetype)distanceRangeNearerThan:(double)distance {
    return [[DistanceRange alloc] initWithMax:distance * DISTANCE_DECREMENT_FACTOR];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%f", _max];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _max = [coder decodeDoubleForKey:@"_max"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeDouble:self.max forKey:@"_max"];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToRange:other];
}

- (BOOL)isEqualToRange:(DistanceRange *)range {
    if (self == range)
        return YES;
    if (range == nil)
        return NO;
    if (self.max != range.max)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return [[NSNumber numberWithDouble:self.max] hash];
}


@end