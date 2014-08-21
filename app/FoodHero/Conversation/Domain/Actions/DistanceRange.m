//
// Created by Jorg on 21/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "DistanceRange.h"
#import "DesignByContractException.h"


const double DISTANCE_DECREMENT_FACTOR = 0.66666;

@implementation DistanceRange {

}

- (instancetype)initWithMax:(double)max {
    self = [super init];
    if (self) {
        if (max < 0) {
            @throw [DesignByContractException createWithReason:@"maxDistance can't be less than 0"];
        }
        _max = max;
    }
    return self;
}


+ (instancetype)distanceRangeNearerThan:(double)distance {
    return [[DistanceRange alloc] initWithMax:distance * DISTANCE_DECREMENT_FACTOR];
}

+ (instancetype)distanceRangeWithoutRestriction {
    return [[DistanceRange alloc] initWithMax:DBL_MAX];
}
@end