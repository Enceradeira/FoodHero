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
#import "RestaurantReviewCommentViewController.h"

@interface RestaurantReviewCommentViewControllerTests : XCTestCase

@end

@implementation RestaurantReviewCommentViewControllerTests {
    RestaurantReviewCommentViewController *_ctrl;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly assembly]];
    _ctrl = [ControllerFactory createRestaurantReviewCommentViewController];
    _ctrl.view.hidden = NO;

    [_ctrl setReview:[[[RestaurantReviewBuilder alloc] withText:@"Nice location"] build]];
}

- (void)test_summaryLabel_ShouldContainSummary {
    assertThat(_ctrl.reviewLabel.text, is(equalTo(@"Nice location")));
}
@end
