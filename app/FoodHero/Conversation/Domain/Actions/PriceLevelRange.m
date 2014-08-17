//
// Created by Jorg on 16/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "PriceLevelRange.h"
#import "DesignByContractException.h"

const NSUInteger GOOGLE_PRICE_LEVEL_MIN = 0;
const NSUInteger GOOGLE_PRICE_LEVEL_MAX = 4;

@implementation PriceLevelRange {

}

+ (instancetype)createWithMin:(NSUInteger)min max:(NSUInteger)max {
    return [[PriceLevelRange alloc] initWithMin:min max:max];
}

+ (instancetype)createFullRange {
    return [PriceLevelRange createWithMin:GOOGLE_PRICE_LEVEL_MIN max:GOOGLE_PRICE_LEVEL_MAX];
}

- (instancetype)initWithMin:(NSUInteger)min max:(NSUInteger)max {
    if (max < min) {
        @throw [DesignByContractException createWithReason:[NSString stringWithFormat:@"max (%u) is smaller than min (%u)", max, min]];
    }
    if (max > GOOGLE_PRICE_LEVEL_MAX) {
        @throw [DesignByContractException createWithReason:[NSString stringWithFormat:@"max (%u) is greater than absolute maximum (%u)", max, GOOGLE_PRICE_LEVEL_MAX]];
    }
    if (min < GOOGLE_PRICE_LEVEL_MIN) {
        @throw [DesignByContractException createWithReason:[NSString stringWithFormat:@"min (%u) is smaller than absolute min (%u)", min, GOOGLE_PRICE_LEVEL_MIN]];
    }
    self = [super init];
    if (self != nil) {
        _max = max;
        _min = min;
    }
    return self;
}

- (PriceLevelRange *)setMaxLowerThan:(NSUInteger)value {
    NSUInteger newMax = value - 1;
    NSUInteger newMin = _min;
    if (newMax < GOOGLE_PRICE_LEVEL_MIN) {
        @throw [DesignByContractException createWithReason:[NSString stringWithFormat:@"invalid value %u", value]];
    }
    if (newMin > newMax) {
        newMin = newMax;
    }
    return [[PriceLevelRange alloc] initWithMin:newMin max:newMax];
}

- (PriceLevelRange *)setMinHigherThan:(NSUInteger)value {
    NSUInteger newMin = value + 1;
    NSUInteger newMax = _max;
    if (newMin > GOOGLE_PRICE_LEVEL_MAX) {
        @throw [DesignByContractException createWithReason:[NSString stringWithFormat:@"invalid value %u", value]];
    }
    if (newMax < newMin) {
        newMax = newMin;
    }
    return [[PriceLevelRange alloc] initWithMin:newMin max:newMax];
}


- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return self.min == ((PriceLevelRange *) other).min && self.max == ((PriceLevelRange *) other).max;
}

@end