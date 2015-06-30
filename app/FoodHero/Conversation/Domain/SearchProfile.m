//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SearchProfile.h"
#import "DesignByContractException.h"

@implementation SearchProfile {

}
+ (instancetype)createWithCuisine:(NSString *)cuisine
                       priceRange:(PriceRange *)priceRange
                      maxDistance:(DistanceRange *)maxDistance
                         occasion:(NSString *)occasion
                         location:(NSString *)location {
    return [[SearchProfile alloc] initWithCuisine:cuisine priceRange:priceRange maxDistance:maxDistance occasion:occasion location:location];
}

- (id)initWithCuisine:(NSString *)cuisine
           priceRange:(PriceRange *)priceRange
          maxDistance:(DistanceRange *)maxDistance
             occasion:(NSString *)occasion
             location:(NSString *)location {
    self = [super init];
    if (self != nil) {

        _cuisine = cuisine;
        _priceRange = priceRange;
        _distanceRange = maxDistance;
        _occasion = occasion;
        _searchLocation = location;
    }
    return self;
}

- (double)scorePlace:(Place *)place normalizedDistance:(double)distance restaurant:(Restaurant *)restaurant {
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
    double scoreForDistance = [self getScoreForDistance:distance];

    // score for cuisineRelevance
    double scoreForCuisineRelevance = place.cuisineRelevance;

    double score = scoreForDistance * scoreForDiffMinPrice * scoreForDiffMaxPrice * scoreForCuisineRelevance;

    /*
    NSLog([NSString stringWithFormat:@"Score: %f Distance: %f Price:%u Name: %@, %@ (%@)", score, distance, place.priceLevel, restaurant.name, restaurant.vicinity, restaurant.placeId]);
    NSLog([NSString stringWithFormat:@"\t\t\tMaxDistance    : %f MinPrice    : %u MaxPrice:     %u", _distanceRange.max, _priceRange.min, _priceRange.max]);
    NSLog([NSString stringWithFormat:@"\t\t\tScoreDistance: %f DiffMinPrice: %f DiffMaxPrice: %f CuisineRelevance: %f", scoreForDistance, scoreForDiffMinPrice, scoreForDiffMaxPrice, scoreForCuisineRelevance]);
    */

    if (score > 1) {
        @throw [DesignByContractException createWithReason:@"Score should not be greater than 1"];
    }
    return score;
}

- (double)getScoreForDistance:(double)distance {
    double maxDistance = _distanceRange == nil ? 1 : _distanceRange.max;
    if (maxDistance == 0 && distance == 0) {
        return 1;
    }

    /* Score-function:
        y = -(x/(a-x))+ 1
        a = -x/(y-1)-x
    */

    // a for x=maxDistance / y=SCORE_AT_MAX_DISTANCE_RANGE
    double a = -maxDistance / (SCORE_AT_MAX_DISTANCE_RANGE - 1) - maxDistance;
    return -distance / (a + distance) + 1;
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