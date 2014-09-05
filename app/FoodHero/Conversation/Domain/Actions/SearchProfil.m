//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SearchProfil.h"
#import "DesignByContractException.h"

@implementation SearchProfil {

}
+ (instancetype)createWithCuisine:(NSString *)cuisine priceRange:(PriceRange *)priceRange maxDistance:(DistanceRange *)maxDistance {
    return [[SearchProfil alloc] initWithCuisine:cuisine priceRange:priceRange maxDistance:maxDistance];
}

- (id)initWithCuisine:(NSString *)cuisine priceRange:(PriceRange *)priceRange maxDistance:(DistanceRange *)maxDistance {
    self = [super init];
    if (self != nil) {

        _cuisine = cuisine;
        _priceRange = priceRange;
        _distanceRange = maxDistance;
    }
    return self;
}

- (double)scorePlace:(Place *)place distance:(double)distance restaurant:(Restaurant *)restaurant {
    if (distance < 0) {
        @throw [DesignByContractException createWithReason:@"distance can't be less than 0"];
    }

    PriceRange *priceRange = _priceRange;

    // score for below price-level-minimum
    double nrIncrementsBelowMinPrice = [self getNrIncrementsBelowMinPrice:place priceRange:priceRange];
    double scoreForDiffMinPrice = [self getScoreForPriceLevelDifference:nrIncrementsBelowMinPrice];

    // score for over price-level-maximum
    double nrIncrementsAboveMaxPrice = [self getNrIncrementsAboveMaxPrice:place priceRange:priceRange];
    double scoreForDiffMaxPrice = [self getScoreForPriceLevelDifference:nrIncrementsAboveMaxPrice];

    // score for over max-distance
    double nrIncrementsAboveMaxDistance = [self getNrIncrementsAboveMaxDistance:distance maxDistance:_distanceRange.max];
    double scoreForDiffMaxDistance = 1;
    if (nrIncrementsAboveMaxDistance != 0) {
        // double scaleFactor = 1.35473452622; // makes score for double distance over maxDistance equal 0.5
        // double adjustment = -0.70946913;
        // scoreForDiffMaxDistance = scaleFactor / (1 + nrIncrementsAboveMaxDistance );
        double n = 1.7094691;
        scoreForDiffMaxDistance = n / (n+nrIncrementsAboveMaxDistance);
    }
    // score for cuisineRelevance
    double scoreForCuisineRelevance = place.cuisineRelevance;

    double score = scoreForDiffMaxDistance * scoreForDiffMinPrice * scoreForDiffMaxPrice * scoreForCuisineRelevance;
    NSLog([NSString stringWithFormat:@"Score: %f Distance: %f Price:%u Name: %@ (%@)", score, distance, place.priceLevel, restaurant.name, restaurant.placeId]);
    NSLog([NSString stringWithFormat:@"\t\t\tMaxDistance    : %f MinPrice    : %u MaxPrice:     %u", _distanceRange.max, _priceRange.min, _priceRange.max]);
    NSLog([NSString stringWithFormat:@"\t\t\tDiffMaxDistance: %f DiffMinPrice: %f DiffMaxPrice: %f CuisineRelevance: %f", scoreForDiffMaxDistance, scoreForDiffMinPrice, scoreForDiffMaxPrice, scoreForCuisineRelevance]);

    if (score > 1) {
        @throw [DesignByContractException createWithReason:@"Score should not be greater than 1"];
    }
    return score;
}

- (double)getScoreForPriceLevelDifference:(double)nrIncrements {
    if (nrIncrements == 0) {
        return 1;
    }
    else if (nrIncrements == 1) {
        return 0.8;
    }
    else if (nrIncrements == 2) {
        return 0.5;
    }
    else if (nrIncrements == 3) {
        return 0.1;
    }
    else {
        return 0.05;
    }
}

- (double)getNrIncrementsAboveMaxDistance:(double)distance maxDistance:(double)maxDistance {
    if (distance <= 0 || distance <= maxDistance) {
        return 0;
    }

    // derived from: distanceDecremented(N) = distance * EVAL_DISTANCE_DECREMENT_FACTOR^n
    double nrIncrements = log(maxDistance / distance) / log(DISTANCE_DECREMENT_FACTOR);
    return nrIncrements;
}

- (double)getNrIncrementsAboveMaxPrice:(Place *)place priceRange:(PriceRange *)priceRange {
    double nrIncrementsAboceMaxPrice = 0;
    if (place.priceLevel > priceRange.max) {
        nrIncrementsAboceMaxPrice = place.priceLevel - priceRange.max;
    }
    return nrIncrementsAboceMaxPrice;
}

- (double)getNrIncrementsBelowMinPrice:(Place *)place priceRange:(PriceRange *)priceRange {
    double nrIncrementsBelowMinPrice = 0;
    if (place.priceLevel < priceRange.min) {
        nrIncrementsBelowMinPrice = priceRange.min - place.priceLevel;
    }
    return nrIncrementsBelowMinPrice;
}

@end