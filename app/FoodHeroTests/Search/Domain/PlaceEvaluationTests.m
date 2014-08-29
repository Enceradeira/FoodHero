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

- (id)placeWithCuisineRelevance:(double)cuisineRelevance;
@end

@implementation PlaceEvaluationTests {
    SearchProfil *_defaultPreference;
}

- (void)setUp {
    [super setUp];
    _defaultPreference = [self preferenceWithPriceMin:GOOGLE_PRICE_LEVEL_MIN priceMax:GOOGLE_PRICE_LEVEL_MAX];
}

- (Restaurant *)placeWithPriceLevel:(NSUInteger)priceLevel {
    return [[[[RestaurantBuilder alloc] withPriceLevel:priceLevel] withCuisineRelevance:1] build];
}

- (Restaurant *)placeWithCuisineRelevance:(double)cuisineRelevance {
    return [[[RestaurantBuilder alloc] withCuisineRelevance:cuisineRelevance] build];
}

- (SearchProfil *)preferenceWithPriceMin:(NSUInteger)priceMin priceMax:(NSUInteger)priceMax {
    return [self preferenceWithPriceMin:priceMin priceMax:priceMax distanceMax:DBL_MAX];
}

- (SearchProfil *)preferenceWithPriceMin:(NSUInteger)priceMin priceMax:(NSUInteger)priceMax distanceMax:(double)distanceMax {
    PriceRange *priceRange = [PriceRange priceRangeWithoutRestriction];
    priceRange = [priceRange setMinHigherThan:priceMin - 1];
    priceRange = [priceRange setMaxLowerThan:priceMax + 1];
    DistanceRange *distance = [DistanceRange distanceRangeNearerThan:distanceMax / DISTANCE_DECREMENT_FACTOR];
    SearchProfil *preferences = [SearchProfil createWithCuisine:@"Asian" priceRange:priceRange maxDistance:distance];
    return preferences;
}

- (void)test_scorePlace_ShouldBeMaxScore_WhenCurrentLocationEqualRestaurantLocationAndPriceLevelMatches {
    Restaurant *place = [[[[RestaurantBuilder alloc] withPriceLevel:3] withCuisineRelevance:1] build];

    assertThatDouble([_defaultPreference scorePlace:place distance:0 restaurant:nil], is(equalTo(@(1))));
}

- (void)test_scorePlace_ShouldBeMaxScore_WhenDistance0AndPriceLevelMatches {
    double score = [_defaultPreference scorePlace:[self placeWithPriceLevel:3] distance:0 restaurant:nil];
    assertThatDouble(score, is(equalTo(@(1))));
}

- (void)test_scorePlace_ShouldBeMaxScore_WhenDistanceLessThanMaxDistanceAndPriceLevelMatches {
    SearchProfil *preference = [self preferenceWithPriceMin:0 priceMax:4 distanceMax:20000];
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:3] distance:0 restaurant:nil], is(equalTo(@(1))));
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:3] distance:10000 restaurant:nil], is(equalTo(@(1))));
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:3] distance:20000 restaurant:nil], is(equalTo(@(1))));
}

- (void)test_scorePlace_ShouldThrowException_WhenDistanceNegative {
    assertThat(^() {
        [_defaultPreference scorePlace:[self placeWithPriceLevel:3] distance:-1 restaurant:nil];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_scorePlace_ShouldDecrease_WhenPriceLevelDifferenceFromMinPriceIncreasesButDistanceStaysTheSame {
    SearchProfil *preference = [self preferenceWithPriceMin:4 priceMax:4];
    double score1 = [preference scorePlace:[self placeWithPriceLevel:4] distance:0 restaurant:nil];
    double score2 = [preference scorePlace:[self placeWithPriceLevel:3] distance:0 restaurant:nil];
    double score3 = [preference scorePlace:[self placeWithPriceLevel:2] distance:0 restaurant:nil];
    double score4 = [preference scorePlace:[self placeWithPriceLevel:1] distance:0 restaurant:nil];
    double score5 = [preference scorePlace:[self placeWithPriceLevel:0] distance:0 restaurant:nil];
    assertThatDouble(score1, is(greaterThan(@(score2))));
    assertThatDouble(score2, is(greaterThan(@(score3))));
    assertThatDouble(score3, is(greaterThan(@(score4))));
    assertThatDouble(score4, is(greaterThan(@(score5))));
    assertThatDouble(score5, is(greaterThan(@(0))));
}

- (void)test_scorePlace_ShouldDecrease_WhenPriceLevelDifferenceFromMaxPriceIncreasesButDistanceStaysTheSame {
    SearchProfil *preference = [self preferenceWithPriceMin:0 priceMax:0];
    double score1 = [preference scorePlace:[self placeWithPriceLevel:0] distance:0 restaurant:nil];
    double score2 = [preference scorePlace:[self placeWithPriceLevel:1] distance:0 restaurant:nil];
    double score3 = [preference scorePlace:[self placeWithPriceLevel:2] distance:0 restaurant:nil];
    double score4 = [preference scorePlace:[self placeWithPriceLevel:3] distance:0 restaurant:nil];
    double score5 = [preference scorePlace:[self placeWithPriceLevel:4] distance:0 restaurant:nil];
    assertThatDouble(score1, is(greaterThan(@(score2))));
    assertThatDouble(score2, is(greaterThan(@(score3))));
    assertThatDouble(score3, is(greaterThan(@(score4))));
    assertThatDouble(score4, is(greaterThan(@(score5))));
    assertThatDouble(score5, is(greaterThan(@(0))));
}

- (void)test_scorePlace_ShouldBeEqual_WhenDiffFromPriceLevelMaxAndPriceLevelMinIsTheSame {
    SearchProfil *preference = [self preferenceWithPriceMin:2 priceMax:3];
    double score1 = [preference scorePlace:[self placeWithPriceLevel:1] distance:0 restaurant:nil];
    double score2 = [preference scorePlace:[self placeWithPriceLevel:4] distance:0 restaurant:nil];
    assertThatDouble(score1, is(equalTo(@(score2))));
}

- (void)test_scorePlace_ShouldIncrease_WhenPriceLevelDoesNotMatchButMaxDistanceIsDecreased {
    SearchProfil *maxDistance6000Preference = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:6000];
    double scoreForMaxDistance6000 = [maxDistance6000Preference scorePlace:[self placeWithPriceLevel:1] distance:12000 restaurant:nil];

    SearchProfil *maxDistance8000Preference = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:8000];
    double scoreForMaxDistance8000 = [maxDistance8000Preference scorePlace:[self placeWithPriceLevel:1] distance:12000 restaurant:nil];

    SearchProfil *maxDistance12000Preference = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:12000];
    double scoreForMaxDistance12000 = [maxDistance12000Preference scorePlace:[self placeWithPriceLevel:1] distance:12000 restaurant:nil];

    assertThatDouble(scoreForMaxDistance6000, is(lessThan(@(scoreForMaxDistance8000))));
    assertThatDouble(scoreForMaxDistance8000, is(lessThan(@(scoreForMaxDistance12000))));
}

- (void)test_scorePlace_ShouldHaveTheSameValue_WhenPlaceIsRelativelyTheSameDistanceFromMaxDistance {
    Place *place = [[[RestaurantBuilder alloc] withPriceLevel:4] build];

    for (double relativeDistanceOverMax = 0; relativeDistanceOverMax < 10; relativeDistanceOverMax++) {
        // distanceMax = 25000 / distance = i * 250000
        double distanceMax1 = 25000;
        SearchProfil *preference1 = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:distanceMax1];
        double score1 = [preference1 scorePlace:place distance:distanceMax1 * relativeDistanceOverMax restaurant:nil];

        // distanceMax = 5000 / distance = i * 5000
        double distanceMax2 = 5000;
        SearchProfil *preference2 = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:distanceMax2];
        double score2 = [preference2 scorePlace:place distance:distanceMax2 * relativeDistanceOverMax restaurant:nil];

        // distanceMax = 200 / distance = i * 200
        double distanceMax3 = 200;
        SearchProfil *preference3 = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:distanceMax3];
        double score3 = [preference3 scorePlace:place distance:distanceMax3 * relativeDistanceOverMax restaurant:nil];

        assertThatDouble(score1, is(equalTo(@(score2))));
        assertThatDouble(score2, is(equalTo(@(score3))));
    }
}

- (void)test_scorePlace_ShouldHaveIncreasinglySmallerChange_WhenDistanceIncreasesByTheSameAbsoluteAmount {
    Place *place = [[[RestaurantBuilder alloc] withPriceLevel:4] build];
    double distanceMax = 1000;
    SearchProfil *preference = [self preferenceWithPriceMin:4 priceMax:4 distanceMax:distanceMax];

    // we expect an interval between score changes that becomes greater as distance increases (inverse exponential)
    double lastScore = 1;
    double lastDiffFromLastScore = 0;
    for (double distance = distanceMax; distance <= 50 * distanceMax; distance += distanceMax / 3) {
        double score = [preference scorePlace:place distance:distance restaurant:nil];
        if (score != lastScore) {
            double diffFromLastScore = lastScore - score;
            if (lastDiffFromLastScore != 0) {
                assertThatDouble(diffFromLastScore, is(lessThan(@(lastDiffFromLastScore))));
            }
            lastDiffFromLastScore = diffFromLastScore;
            lastScore = score;

        }
    }
}

- (void)test_scorePlace_ShouldReturnSensibleScores_WhenPriceLevelDoesNotMatch {
    SearchProfil *preference = [self preferenceWithPriceMin:4 priceMax:4];

    // no diff ok -> score 1
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:4] distance:500 restaurant:nil], is(equalTo(@(1))));
    // diff 1 -> ok, can't be to bad -> score 0.8
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:3] distance:500 restaurant:nil], is(equalTo(@(0.8))));
    // diff 2 -> hmmm, if we change our mind a git, will be ok -> score 0.5
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:2] distance:500 restaurant:nil], is(equalTo(@(0.5))));
    // diff 3 -> that's not what we are looking for, I prefer something further away -> score 0.1
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:1] distance:500 restaurant:nil], is(equalTo(@(0.1))));
    // diff 4 -> no way, that's not suitable for our occasion -> score 0.05
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:0] distance:500 restaurant:nil], is(equalTo(@(0.05))));
}

- (void)test_scorePlace_ShouldRerunSensibleScores_WhenOverMaxDistance {
    for (double maxDistance = 500; maxDistance < 50000; maxDistance /= DISTANCE_DECREMENT_FACTOR) {
        SearchProfil *preference = [self preferenceWithPriceMin:0 priceMax:4 distanceMax:maxDistance];

        // diff is less than 0 -> superb -> score 1.0
        assertThatDouble([preference scorePlace:[self placeWithPriceLevel:4] distance:maxDistance / 2 restaurant:nil], is(equalTo(@(1))));
        // diff is 0 -> very good -> score 1.0
        assertThatDouble([preference scorePlace:[self placeWithPriceLevel:4] distance:maxDistance restaurant:nil], is(equalTo(@(1))));
        // double as faraway a maxDistance -> not so good, but somehow acceptable -> score 0.5
        double score = [preference scorePlace:[self placeWithPriceLevel:4] distance:maxDistance * 2 restaurant:nil];
        assertThatDouble(score, is(greaterThan(@(0.4999))));
        assertThatDouble(score, is(lessThan(@(0.5001))));
    }
}

- (void)test_scorePlace_ShouldReturnLowerScore_WhenPlaceIsLessRelevant {
    SearchProfil *preference = [self preferenceWithPriceMin:4 priceMax:4];

    double score1 = [preference scorePlace:[self placeWithCuisineRelevance:0.5] distance:400 restaurant:nil];
    double score2 = [preference scorePlace:[self placeWithCuisineRelevance:0.8] distance:400 restaurant:nil];

    assertThatDouble(score1, is(lessThan(@(score2))));
}


@end
