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
    assertThatInt(rating.reviews.count, is(equalTo(@(2))));
}

- (void)test_create_ShouldInitializeCorrectly {
    RestaurantReview *review1 = [[RestaurantReviewBuilder alloc] build];
    RestaurantReview *review2 = [[RestaurantReviewBuilder alloc] build];

    RestaurantRating *rating = [RestaurantRating createRating:3.2 withReviews:@[review1, review2]];

    assertThat(rating, is(notNilValue()));
    assertThatDouble(rating.rating, is(equalTo(@(3.2))));
    assertThatInt(rating.reviews.count, is(greaterThan(@(0))));
}

- (void)test_create_ShouldDropEmptyReviews_WhenTextOnReviewIsEmpty {
    RestaurantReview *review1 = [[[RestaurantReviewBuilder alloc] withText:@""] build];
    RestaurantReview *review2 = [[[RestaurantReviewBuilder alloc] withText:@"Nice place"] build];

    RestaurantRating *rating = [RestaurantRating createRating:3.2 withReviews:@[review1, review2]];
    assertThat(rating, is(notNilValue()));
    assertThatInt(rating.reviews.count, is(equalTo(@(1))));
}

@end
