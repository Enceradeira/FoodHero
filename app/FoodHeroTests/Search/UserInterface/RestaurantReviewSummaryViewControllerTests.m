//
//  RestaurantReviewSummaryViewControllerTests.m
//  FoodHero
//
//  Created by Jorg on 02/11/14.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest.h>
#import "ControllerFactory.h"
#import "StubAssembly.h"
#import "TyphoonComponents.h"
#import "RestaurantReviewSummaryViewController.h"
#import "RestaurantRatingBuilder.h"
#import "RestaurantReviewBuilder.h"
#import "RestaurantBuilder.h"
#import "RatingStarsImageRepository.h"

@interface RestaurantReviewSummaryViewControllerTests : XCTestCase

@end

@implementation RestaurantReviewSummaryViewControllerTests {
    RestaurantReviewSummaryViewController *_ctrl;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly assembly]];
    _ctrl = [ControllerFactory createRestaurantReviewSummaryViewController];
    _ctrl.view.hidden = NO;

    NSArray *reviews = @[[[[RestaurantReviewBuilder alloc] withText:@"Nice location"] build]];
    RestaurantRating *rating = [[[[RestaurantRatingBuilder alloc] withRating:3.2] withReviews:reviews] build];
    [_ctrl setRating:rating];
}


- (void)test_ratingLabel_ShouldContainRating {
    assertThat(_ctrl.ratingLabel.text, is(equalTo(@"3.2")));
}

- (void)test_ratingImage_ShouldContainRatingImage {
    UIImage *image = [RatingStarsImageRepository getImageForRating:3].image;
    assertThat(_ctrl.ratingImage.image, is(equalTo(image)));
}

- (void)test_summaryLabel_ShouldContainSummary {
    assertThat(_ctrl.summaryLabel.text, is(equalTo(@"Nice location")));
}
@end
