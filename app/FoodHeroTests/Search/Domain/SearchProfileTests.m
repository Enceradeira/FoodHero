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
#import "SearchProfile.h"
#import "FoodHero-Swift.h"

@interface SearchProfileTests : XCTestCase

- (id)placeWithCuisineRelevance:(double)cuisineRelevance;
@end

@implementation SearchProfileTests {
    SearchProfile *_defaultPreference;
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

- (SearchProfile *)preferenceWithPriceMin:(NSUInteger)priceMin priceMax:(NSUInteger)priceMax {
    PriceRange *priceRange = [PriceRange priceRangeWithoutRestriction];
    priceRange = [priceRange setMinHigherThan:priceMin - 1];
    priceRange = [priceRange setMaxLowerThan:priceMax + 1];
    DistanceRange *distance = [DistanceRange distanceRangeNearerThan:MAX_NORMAL_DISTANCE / DISTANCE_DECREMENT_FACTOR];
    SearchProfile *preferences = [SearchProfile createWithCuisine:@"Asian" priceRange:priceRange maxDistance:distance occasion:[Occasions breakfast] location:nil];
    return preferences;
}

- (void)test_scorePlace_ShouldBeMaxScore_WhenCurrentLocationEqualRestaurantLocationAndPriceLevelMatches {
    Restaurant *place = [[[[RestaurantBuilder alloc] withPriceLevel:3] withCuisineRelevance:1] build];

    assertThatDouble([_defaultPreference scorePlace:place normalizedDistance:0 restaurant:nil], is(equalTo(@(1))));
}

- (void)test_scorePlace_ShouldBeMaxScore_WhenDistance0AndPriceLevelMatches {
    double score = [_defaultPreference scorePlace:[self placeWithPriceLevel:3] normalizedDistance:0 restaurant:nil];
    assertThatDouble(score, is(equalTo(@(1))));
}

- (void)test_scorePlace_ShouldThrowException_WhenDistanceNegative {
    assertThat(^() {
        [_defaultPreference scorePlace:[self placeWithPriceLevel:3] normalizedDistance:-1 restaurant:nil];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_scorePlace_ShouldDecrease_WhenPriceLevelDifferenceFromMinPriceIncreasesButDistanceStaysTheSame {
    SearchProfile *preference = [self preferenceWithPriceMin:4 priceMax:4];
    double score1 = [preference scorePlace:[self placeWithPriceLevel:4] normalizedDistance:0 restaurant:nil];
    double score2 = [preference scorePlace:[self placeWithPriceLevel:3] normalizedDistance:0 restaurant:nil];
    double score3 = [preference scorePlace:[self placeWithPriceLevel:2] normalizedDistance:0 restaurant:nil];
    double score4 = [preference scorePlace:[self placeWithPriceLevel:1] normalizedDistance:0 restaurant:nil];
    double score5 = [preference scorePlace:[self placeWithPriceLevel:0] normalizedDistance:0 restaurant:nil];
    assertThatDouble(score1, is(greaterThan(@(score2))));
    assertThatDouble(score2, is(greaterThan(@(score3))));
    assertThatDouble(score3, is(greaterThan(@(score4))));
    assertThatDouble(score4, is(greaterThan(@(score5))));
    assertThatDouble(score5, is(greaterThan(@(0))));
}

- (void)test_scorePlace_ShouldDecrease_WhenPriceLevelDifferenceFromMaxPriceIncreasesButDistanceStaysTheSame {
    SearchProfile *preference = [self preferenceWithPriceMin:0 priceMax:0];
    double score1 = [preference scorePlace:[self placeWithPriceLevel:0] normalizedDistance:0 restaurant:nil];
    double score2 = [preference scorePlace:[self placeWithPriceLevel:1] normalizedDistance:0 restaurant:nil];
    double score3 = [preference scorePlace:[self placeWithPriceLevel:2] normalizedDistance:0 restaurant:nil];
    double score4 = [preference scorePlace:[self placeWithPriceLevel:3] normalizedDistance:0 restaurant:nil];
    double score5 = [preference scorePlace:[self placeWithPriceLevel:4] normalizedDistance:0 restaurant:nil];
    assertThatDouble(score1, is(greaterThan(@(score2))));
    assertThatDouble(score2, is(greaterThan(@(score3))));
    assertThatDouble(score3, is(greaterThan(@(score4))));
    assertThatDouble(score4, is(greaterThan(@(score5))));
    assertThatDouble(score5, is(greaterThan(@(0))));
}

- (void)test_scorePlace_ShouldBeEqual_WhenDiffFromPriceLevelMaxAndPriceLevelMinIsTheSame {
    SearchProfile *preference = [self preferenceWithPriceMin:2 priceMax:3];
    double score1 = [preference scorePlace:[self placeWithPriceLevel:1] normalizedDistance:0 restaurant:nil];
    double score2 = [preference scorePlace:[self placeWithPriceLevel:4] normalizedDistance:0 restaurant:nil];
    assertThatDouble(score1, is(equalTo(@(score2))));
}

- (void)test_scorePlace_ShouldHaveIncreasinglySmallerChange_WhenDistanceIncreasesByTheSameAbsoluteAmount {
    double cuisineRelevance = 1;
    Place *place = [[[[RestaurantBuilder alloc] withPriceLevel:4] withCuisineRelevance:cuisineRelevance] build];
    double distanceMax = MAX_NORMAL_DISTANCE;
    SearchProfile *preference = [self preferenceWithPriceMin:4 priceMax:4];

    // we expect an interval between score changes that becomes greater as distance increases (inverse exponential)
    double lastScore = cuisineRelevance;
    double lastDiffFromLastScore = 0;
    for (double distance = distanceMax; distance <= 50 * distanceMax; distance += distanceMax / 3) {
        double score = [preference scorePlace:place normalizedDistance:distance restaurant:nil];
        NSLog(@"Distance: %f Score: %f", distance, score);
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
    SearchProfile *preference = [self preferenceWithPriceMin:4 priceMax:4];

    // no diff ok -> score 1
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:4] normalizedDistance:0 restaurant:nil], is(equalTo(@(1))));
    // diff 1 -> ok, can't be to bad -> score 0.8
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:3] normalizedDistance:0 restaurant:nil], is(equalTo(@(0.8))));
    // diff 2 -> hmmm, if we change our mind a git, will be ok -> score 0.5
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:2] normalizedDistance:0 restaurant:nil], is(equalTo(@(0.5))));
    // diff 3 -> that's not what we are looking for, I prefer something further away -> score 0.1
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:1] normalizedDistance:0 restaurant:nil], is(equalTo(@(0.1))));
    // diff 4 -> no way, that's not suitable for our occasion -> score 0.05
    assertThatDouble([preference scorePlace:[self placeWithPriceLevel:0] normalizedDistance:0 restaurant:nil], is(equalTo(@(0.05))));
}

- (void)test_scorePlace_ShouldReturnLowerScore_WhenPlaceIsLessRelevant {
    SearchProfile *preference = [self preferenceWithPriceMin:4 priceMax:4];

    double score1 = [preference scorePlace:[self placeWithCuisineRelevance:0.5] normalizedDistance:400 restaurant:nil];
    double score2 = [preference scorePlace:[self placeWithCuisineRelevance:0.8] normalizedDistance:400 restaurant:nil];

    assertThatDouble(score1, is(lessThan(@(score2))));
}

- (void)test_ScorePlace_ShouldBeLessOrEqual1_WhenRestaurantIsCloserThanMaxDistance {
    SearchProfile *preference = [self preferenceWithPriceMin:0 priceMax:4];

    double score = [preference scorePlace:[self placeWithCuisineRelevance:1] normalizedDistance:0.99 restaurant:nil];
    assertThatDouble(score, is(lessThanOrEqualTo(@1)));
}

- (void)test_ScorePlace_ShouldYieldCorrectResult_WhenDistanceRangeNil {
    SearchProfile *preference = [self preferenceWithPriceMin:0 priceMax:4];

    // worse score at max distance is SCORE_AT_MAX_DISTANCE_RANGE
    double score = [preference scorePlace:[self placeWithCuisineRelevance:1] normalizedDistance:1 restaurant:nil];
    assertThatDouble(score, is(lessThanOrEqualTo(@(SCORE_AT_MAX_DISTANCE_RANGE))));

    // score at 0 distance is 1
    score = [preference scorePlace:[self placeWithCuisineRelevance:1] normalizedDistance:0 restaurant:nil];
    assertThatDouble(score, is(lessThanOrEqualTo(@(1))));
}

- (void)test_ScorePlace_ShouldYieldCorrectResult_WhenDistanceRangeSpecified {
    PriceRange *priceRange = [PriceRange priceRangeWithoutRestriction];
    const double MAX_DISTANCE_RANGE = 0.25;
    DistanceRange *range = [DistanceRange distanceRangeNearerThan:MAX_DISTANCE_RANGE / DISTANCE_DECREMENT_FACTOR];
    SearchProfile *preferences = [SearchProfile createWithCuisine:@"Asian" priceRange:priceRange maxDistance:range occasion:[Occasions breakfast] location:nil];

    // score at max distance is greater than 0
    double scoreAtMaxDistance = [preferences scorePlace:[self placeWithPriceLevel:0] normalizedDistance:1 restaurant:nil];
    assertThatDouble(scoreAtMaxDistance, is(greaterThan(@(0))));

    // score over max distance range is less than SCORE_AT_MAX_DISTANCE_RANGE
    double scoreAtOverMaxDistanceRange = [preferences scorePlace:[self placeWithPriceLevel:0] normalizedDistance:MAX_DISTANCE_RANGE + 0.1 restaurant:nil];
    assertThatDouble(scoreAtOverMaxDistanceRange, is(lessThan(@(SCORE_AT_MAX_DISTANCE_RANGE))));

    // score at max distance range is SCORE_AT_MAX_DISTANCE_RANGE
    double scoreAtMaxDistanceRange = [preferences scorePlace:[self placeWithPriceLevel:0] normalizedDistance:MAX_DISTANCE_RANGE restaurant:nil];
    assertThatDouble(scoreAtMaxDistanceRange, is(closeTo(SCORE_AT_MAX_DISTANCE_RANGE, 0.001)));

    // score at 0 distance is 1
    double scoreAt0Distance = [preferences scorePlace:[self placeWithCuisineRelevance:1] normalizedDistance:0 restaurant:nil];
    assertThatDouble(scoreAt0Distance, is(equalToDouble(1)));
}

- (void)test_ScorePlace_ShouldBe1_WhenDistanceAndMaxDistanceRange0 {
    PriceRange *priceRange = [PriceRange priceRangeWithoutRestriction];
    DistanceRange *range = [DistanceRange distanceRangeNearerThan:0];
    SearchProfile *preferences = [SearchProfile createWithCuisine:@"Asian" priceRange:priceRange maxDistance:range occasion:[Occasions breakfast] location:nil];

    double score = [preferences scorePlace:[self placeWithPriceLevel:0] normalizedDistance:0 restaurant:nil];
    assertThatDouble(score, is(equalToDouble(1)));
}


@end
