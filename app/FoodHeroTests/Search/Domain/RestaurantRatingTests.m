//
//  RestaurantRatingTests.m
//  FoodHero
//
//  Created by Jorg on 31/10/14.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "RestaurantReviewBuilder.h"
#import "RestaurantRating.h"

@interface RestaurantRatingTests : XCTestCase

@end

@implementation RestaurantRatingTests

- (void)test_create_ShouldInitializeSummaryWithFirstReview_WhenTwoReviewsAvailable {
    RestaurantReview *review1 = [[RestaurantReviewBuilder alloc] build];
    RestaurantReview *review2 = [[RestaurantReviewBuilder alloc] build];

    RestaurantRating *rating = [RestaurantRating createRating:3.2 withReviews:@[review1, review2]];
    assertThat(rating, is(notNilValue()));
    assertThat(rating.summary, is(equalTo(review1)));
    assertThatInt(rating.reviews.count, is(equalTo(@(1))));
    assertThat(rating.reviews[0], is(equalTo(review2)));
}

- (void)test_create_ShouldInitializeSummaryWithFirstReviewAndSetReviewsEmpty_WhenOneReviewAvailable {
    RestaurantReview *review = [[RestaurantReviewBuilder alloc] build];

    RestaurantRating *rating = [RestaurantRating createRating:3.2 withReviews:@[review]];
    assertThat(rating, is(notNilValue()));
    assertThat(rating.summary, is(equalTo(review)));
    assertThatInt(rating.reviews.count, is(equalTo(@(0))));
}

- (void)test_create_ShouldInitializeSummaryWithNil_WhenNoReviewAvailable {

    RestaurantRating *rating = [RestaurantRating createRating:3.2 withReviews:@[]];
    assertThat(rating, is(notNilValue()));
    assertThat(rating.summary, nilValue());
    assertThatInt(rating.reviews.count, is(equalTo(@(0))));
}

- (void)test_create_ShouldInitializeCorrectly {
    RestaurantReview *review1 = [[RestaurantReviewBuilder alloc] build];
    RestaurantReview *review2 = [[RestaurantReviewBuilder alloc] build];

    RestaurantRating *rating = [RestaurantRating createRating:3.2 withReviews:@[review1, review2]];

    assertThat(rating, is(notNilValue()));
    assertThatDouble(rating.rating, is(equalTo(@(3.2))));
    assertThat(rating.summary, is(notNilValue()));
    assertThatInt(rating.reviews.count, is(greaterThan(@(0))));
}

@end
