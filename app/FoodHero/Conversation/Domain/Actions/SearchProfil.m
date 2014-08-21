//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SearchProfil.h"
#import "DesignByContractException.h"
#import "Place.h"

const double EVAL_MAX_SCORE = 1;
const double EVAL_MIN_SCORE = 0;
const double EVAL_DISTANCE_DECREMENT_FACTOR = 0.66666;

const double MAX_NR_DESCRETE_RANGES = 10;

@implementation SearchProfil {

}
+ (instancetype)createWithCuisine:(NSString *)cuisine priceRange:(PriceLevelRange *)priceRange maxDistance:(double)maxDistance {
    return [[SearchProfil alloc] initWithCuisine:cuisine priceRange:priceRange maxDistance:maxDistance];
}

- (id)initWithCuisine:(NSString *)cuisine priceRange:(PriceLevelRange *)priceRange maxDistance:(double)maxDistance {
    self = [super init];
    if (self != nil) {
        if (maxDistance < 0) {
            @throw [DesignByContractException createWithReason:@"maxDistance can't be less than 0"];
        }
        _cuisine = cuisine;
        _priceRange = priceRange;
        _maxDistance = maxDistance;
    }
    return self;
}

- (double)scorePlace:(Place *)place distance:(double)distance{
    if (distance < 0) {
        @throw [DesignByContractException createWithReason:@"distance can't be less than 0"];
    }

    NSUInteger nrPriceLevels = GOOGLE_PRICE_LEVEL_MAX - GOOGLE_PRICE_LEVEL_MIN + 1;
    PriceLevelRange *priceRange = _priceRange;

    // score for below price-level-minimum
    double nrIncrementsBelowMinPrice = [self getNrIncrementsBelowMinPrice:place priceRange:priceRange];
    double normalizedNrIncrementsBelowMinPrice = [self normalizeNrIncrements:nrIncrementsBelowMinPrice usefulMaxNrRanges:nrPriceLevels];
    double scoreForDiffMinPrice = 1 / (1 + normalizedNrIncrementsBelowMinPrice);

    // score for over price-level-maximum
    double nrIncrementsAboveMaxPrice = [self getNrIncrementsAboveMaxPrice:place priceRange:priceRange];
    double normalizedNrIncrementsAboveMaxPrice = [self normalizeNrIncrements:nrIncrementsAboveMaxPrice usefulMaxNrRanges:nrPriceLevels];
    double scoreForDiffMaxPrice = 1 / (1 + normalizedNrIncrementsAboveMaxPrice);

    // score for over max-distance
    double nrIncrementsAboveMaxDistance = [self getNrIncrementsAboveMaxDistance:distance maxDistance:_maxDistance];
    double normalizedNrIncrementsAboveMaxDistance = [self normalizeNrIncrements:nrIncrementsAboveMaxDistance usefulMaxNrRanges:MAX_NR_DESCRETE_RANGES];
    double scoreForDiffMaxDistance = 1 / (1 + normalizedNrIncrementsAboveMaxDistance);

    return scoreForDiffMaxDistance * scoreForDiffMinPrice * scoreForDiffMaxPrice;
}

- (double)normalizeNrIncrements:(double)increments usefulMaxNrRanges:(double)usefulMaxNrRanges {
    if (increments > usefulMaxNrRanges) {
        return MAX_NR_DESCRETE_RANGES;
    }
    double factor = (1 / usefulMaxNrRanges) * increments;  // factor 0 .. 1
    return MAX_NR_DESCRETE_RANGES * factor;
}

- (double)getNrIncrementsAboveMaxDistance:(double)distance maxDistance:(double)maxDistance {
    if (distance <= 0 || distance <= maxDistance) {
        return 0;
    }

    // derived from: distanceDecremented(N) = distance * EVAL_DISTANCE_DECREMENT_FACTOR^n
    double nrIncrements = log(maxDistance / distance) / log(EVAL_DISTANCE_DECREMENT_FACTOR);
    return nrIncrements;
}

- (double)getNrIncrementsAboveMaxPrice:(Place *)place priceRange:(PriceLevelRange *)priceRange {
    double nrIncrementsAboceMaxPrice = 0;
    if (place.priceLevel > priceRange.max) {
        nrIncrementsAboceMaxPrice = place.priceLevel - priceRange.max;
    }
    return nrIncrementsAboceMaxPrice;
}

- (double)getNrIncrementsBelowMinPrice:(Place *)place priceRange:(PriceLevelRange *)priceRange {
    double nrIncrementsBelowMinPrice = 0;
    if (place.priceLevel < priceRange.min) {
        nrIncrementsBelowMinPrice = priceRange.min - place.priceLevel;
    }
    return nrIncrementsBelowMinPrice;
}

@end