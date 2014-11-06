//
//  RestaurantReviewPageViewControllerTests.m
//  FoodHero
//
//  Created by Jorg on 02/11/14.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest.h>
#import "RestaurantRatingBuilder.h"
#import "RestaurantReviewBuilder.h"
#import "ControllerFactory.h"
#import "StubAssembly.h"
#import "TyphoonComponents.h"
#import "RestaurantReviewPageViewController.h"
#import "RestaurantReviewSummaryViewController.h"
#import "RestaurantReviewCommentViewController.h"
#import "RestaurantBuilder.h"

@interface RestaurantReviewPageViewControllerTests : XCTestCase

@end

@implementation RestaurantReviewPageViewControllerTests {
    RestaurantReviewPageViewController *_ctrl;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly assembly]];
    _ctrl = [ControllerFactory createRestaurantReviewPageViewController];
}

- (void)showView {
    _ctrl.view.hidden = NO;
}

- (RestaurantReview *)review:(NSString *)text {
    return [[[RestaurantReviewBuilder alloc] withText:text] build];
}

- (RestaurantRating *)rating:(NSArray *)reviews {
    return [[[[RestaurantRatingBuilder alloc] withRating:3.2] withReviews:reviews] build];
}

- (void)test_viewDidLoad_DisplaysSummaryController {
    [_ctrl setRestaurant:[[RestaurantBuilder alloc] build]];

    [self showView];
    assertThatInt(_ctrl.viewControllers.count, is(equalToInt(1)));
    UIViewController *subController = _ctrl.viewControllers[0];
    assertThat(subController.class, is(RestaurantReviewSummaryViewController.class));
}

- (void)test_viewControllerShouldNavigateCorrectly_When2Reviews {
    RestaurantReview *summary = [self review:@"Nice location"];
    RestaurantReview *review = [self review:@"Good food"];
    RestaurantRating *rating = [self rating:@[summary, review]];
    [_ctrl setRestaurant:[[[RestaurantBuilder alloc] withReview:rating] build]];
    [self showView];

    // first page is displayed (summary)
    UIViewController *nextController = _ctrl.viewControllers[0];
    assertThat(((RestaurantReviewSummaryViewController *) nextController).rating, is(equalTo(rating)));
    // go to next page (review)
    nextController = [_ctrl pageViewController:_ctrl viewControllerAfterViewController:nextController];
    assertThat(nextController.class, is(RestaurantReviewCommentViewController.class));
    assertThat(((RestaurantReviewCommentViewController *) nextController).review, is(equalTo(review)));
    // go to next page (which doesn't exist)
    nextController = [_ctrl pageViewController:_ctrl viewControllerAfterViewController:nextController];
    assertThat(nextController, is(nilValue()));
    // go to prev controller (summary)
    nextController = [_ctrl pageViewController:_ctrl viewControllerBeforeViewController:nextController];
    assertThat(((RestaurantReviewSummaryViewController *) nextController).rating, is(equalTo(rating)));
    // go to prev controller (which doesn't exists)
    nextController = [_ctrl pageViewController:_ctrl viewControllerBeforeViewController:nextController];
    assertThat(nextController, is(nilValue()));
}


@end
