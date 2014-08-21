//
//  PlaceEvaluationTests.m
//  FoodHero
//
//  Created by Jorg on 20/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "RestaurantBuilder.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"
#import "SearchProfil.h"

@interface PlaceEvaluationTests : XCTestCase

@end

@implementation PlaceEvaluationTests {
    SearchProfil *_defaultPreference;
}

- (void)setUp {
    [super setUp];
    _defaultPreference = [self preferenceWithPriceMin:GOOGLE_PRICE_LEVEL_MIN priceMax:GOOGLE_PRICE_LEVEL_MAX];
}

- (Restaurant *)placeWithPriceLevel:(NSUInteger)priceLevel {
    return [[[RestaurantBuilder alloc] withPriceLevel:priceLevel] build];
}

- (SearchProfil *)preferenceWithPriceMin:(NSUInteger)priceMin priceMax:(NSUInteger)priceMax {
    return [self preferenceWithPriceMin:priceMin priceMax:priceMax distanceMax:DBL_MAX];
}


- (SearchProfil *)preferenceWithPriceMin:(NSUInteger)priceMin priceMax:(NSUInteger)priceMax distanceMax:(double)distanceMax {
    PriceLevelRange *priceRange = [PriceLevelRange createFullRange];
    priceRange = [priceRange setMinHigherThan:priceMin - 1];
    priceRange = [priceRange setMaxLowerThan:priceMax + 1];
    SearchProfil *preferences = [SearchProfil createWithCuisine:@"Asian" priceRange:priceRange maxDistance:distanceMax];
    return preferences;
}

- (void)test_scorePlace_ShouldBeMaxScore_WhenCurrentLocationEqualRestaurantLocationAndPriceLevelMatches {
    Restaurant *place = [[[RestaurantBuilder alloc] withPriceLevel:3] build];

    assertThatDouble([_defaultPreference scorePlace:place distance:0], is(equalTo(@(EVAL_MAX_SCORE))));
}

- (void)test_scorePlace_ShouldBeMaxScore_WhenDistance0AndPriceLevelMatches {
    double score = [_defaultPreference scorePlace:[self placeWithPriceLevel:3] distance:0];
    assertThatDouble(score, is(equalTo(@(EVAL_MAX_SCORE))));
}

- (void)test_scorePlace_ShouldBeMaxScore_WhenDistanceLessThanMaxDistanceAndPriceLevelMatches {
    SearchProfil *preference = [self preferenceWithPriceMin:0 priceMax:4 distanceMax:20000];
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:3] distance:0], is(equalTo(@(EVAL_MAX_SCORE))));
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:3] distance:10000], is(equalTo(@(EVAL_MAX_SCORE))));
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:3] distance:20000], is(equalTo(@(EVAL_MAX_SCORE))));
}

- (void)test_scorePlace_ShouldThrowException_WhenDistanceNegative {
    assertThat(^() {
        [_defaultPreference scorePlace:[self placeWithPriceLevel:3] distance:-1];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_scorePlace_ShouldDecrease_WhenPriceLevelDifferenceFromMinPriceIncreasesButDistanceStaysTheSame {
    SearchProfil *preference = [self preferenceWithPriceMin:4 priceMax:4];
    double score1 = [preference scorePlace:[self placeWithPriceLevel:4] distance:0];
    double score2 = [preference scorePlace:[self placeWithPriceLevel:3] distance:0];
    double score3 = [preference scorePlace:[self placeWithPriceLevel:2] distance:0];
    double score4 = [preference scorePlace:[self placeWithPriceLevel:1] distance:0];
    double score5 = [preference scorePlace:[self placeWithPriceLevel:0] distance:0];
    assertThatDouble(score1, is(greaterThan(@(score2))));
    assertThatDouble(score2, is(greaterThan(@(score3))));
    assertThatDouble(score3, is(greaterThan(@(score4))));
    assertThatDouble(score4, is(greaterThan(@(score5))));
    assertThatDouble(score5, is(greaterThan(@(EVAL_MIN_SCORE))));
}

- (void)test_scorePlace_ShouldDecrease_WhenPriceLevelDifferenceFromMaxPriceIncreasesButDistanceStaysTheSame {
    SearchProfil *preference = [self preferenceWithPriceMin:0 priceMax:0];
    double score1 = [preference scorePlace:[self placeWithPriceLevel:0] distance:0];
    double score2 = [preference scorePlace:[self placeWithPriceLevel:1] distance:0];
    double score3 = [preference scorePlace:[self placeWithPriceLevel:2] distance:0];
    double score4 = [preference scorePlace:[self placeWithPriceLevel:3] distance:0];
    double score5 = [preference scorePlace:[self placeWithPriceLevel:4] distance:0];
    assertThatDouble(score1, is(greaterThan(@(score2))));
    assertThatDouble(score2, is(greaterThan(@(score3))));
    assertThatDouble(score3, is(greaterThan(@(score4))));
    assertThatDouble(score4, is(greaterThan(@(score5))));
    assertThatDouble(score5, is(greaterThan(@(EVAL_MIN_SCORE))));
}

- (void)test_scorePlace_ShouldBeEqual_WhenDiffFromPriceLevelMaxAndPriceLevelMinIsTheSame {
    SearchProfil *preference = [self preferenceWithPriceMin:2 priceMax:3];
    double score1 = [preference scorePlace:[self placeWithPriceLevel:1] distance:0];
    double score2 = [preference scorePlace:[self placeWithPriceLevel:4] distance:0];
    assertThatDouble(score1, is(equalTo(@(score2))));
}

- (void)test_scorePlace_ShouldIncrease_WhenPriceLevelDoesNotMatchButMaxDistanceIsDecreased {
    SearchProfil *maxDistance6000Preference = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:6000];
    double scoreForMaxDistance6000 = [maxDistance6000Preference scorePlace:[self placeWithPriceLevel:1] distance:12000];

    SearchProfil *maxDistance8000Preference = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:8000];
    double scoreForMaxDistance8000 = [maxDistance8000Preference scorePlace:[self placeWithPriceLevel:1] distance:12000];

    SearchProfil *maxDistance12000Preference = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:12000];
    double scoreForMaxDistance12000 = [maxDistance12000Preference scorePlace:[self placeWithPriceLevel:1] distance:12000];

    assertThatDouble(scoreForMaxDistance6000, is(lessThan(@(scoreForMaxDistance8000))));
    assertThatDouble(scoreForMaxDistance8000, is(lessThan(@(scoreForMaxDistance12000))));
}

- (void)test_scorePlace_ShouldBeHigherForClosePlaceWithPriceLevelMismatch_WhenMaxDistanceIs0 {
    SearchProfil *preference = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:0];
    double scoreForClosePlaceWithMismatchingPrice = [preference scorePlace:[self placeWithPriceLevel:0] distance:0];
    double scoreForFarAwayPlaceWithMatchingPrice = [preference scorePlace:[self placeWithPriceLevel:4] distance:2000];

    assertThatDouble(scoreForClosePlaceWithMismatchingPrice, is(greaterThan(@(scoreForFarAwayPlaceWithMatchingPrice))));
}

- (void)test_scorePlace_ShouldBeEqual_WhenPriceLevelMismatchedBy1RangesAndDistanceMismatchedBy2Ranges {
    SearchProfil *preference = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:25000];

    // price-level mismatches by 1 range
    double scoreForMismatchingPriceLevel = [preference scorePlace:[self placeWithPriceLevel:3] distance:25000];

    // distance mismatches by 2 ranges
    double distanceForFurtherAway = 25000 / EVAL_DISTANCE_DECREMENT_FACTOR / EVAL_DISTANCE_DECREMENT_FACTOR;
    double scoreForMismatchingDistance = [preference scorePlace:[self placeWithPriceLevel:4] distance:distanceForFurtherAway];

    assertThatDouble(scoreForMismatchingPriceLevel, is(equalTo(@(scoreForMismatchingDistance))));
}

- (void)test_scorePlace_ShouldBeEqual_WhenPriceLevelMismatchedBy3RangesAndDistanceMismatchedBy6Ranges {
    SearchProfil *preference = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:25000];

    // price-level mismatches by 3 ranges
    double scoreForMismatchingPriceLevel = [preference scorePlace:[self placeWithPriceLevel:4 - 3] distance:25000];

    // distance mismatches by 6 ranges
    double distanceFurtherAway = 25000 / EVAL_DISTANCE_DECREMENT_FACTOR / EVAL_DISTANCE_DECREMENT_FACTOR / EVAL_DISTANCE_DECREMENT_FACTOR / EVAL_DISTANCE_DECREMENT_FACTOR / EVAL_DISTANCE_DECREMENT_FACTOR / EVAL_DISTANCE_DECREMENT_FACTOR;
    double scoreForMismatchingDistance = [preference scorePlace:[self placeWithPriceLevel:4] distance:distanceFurtherAway];

    assertThatDouble(scoreForMismatchingPriceLevel, is(equalTo(@(scoreForMismatchingDistance))));
}

@end
