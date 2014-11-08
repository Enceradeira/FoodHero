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
#import "RestaurantBuilder.h"
#import "PhotoBuilder.h"

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


- (NotebookPageHostViewController *)viewControllerAfterViewController:(NotebookPageHostViewController *)viewControllerAfterViewController {
    return (NotebookPageHostViewController *) [_ctrl pageViewController:_ctrl viewControllerAfterViewController:viewControllerAfterViewController];
}

- (NotebookPageHostViewController *)viewControllerBeforeViewController:(NotebookPageHostViewController *)viewControllerBeforeViewController {
    return (NotebookPageHostViewController *) [_ctrl pageViewController:_ctrl viewControllerBeforeViewController:viewControllerBeforeViewController];
}

- (void)test_viewControllerShouldNavigateCorrectly{
    // Summary, Review and Photo (3 Controllers)
    RestaurantReview *review = [self review:@"Good food"];
    RestaurantRating *rating = [self rating:@[ review]];
    id photo1 = [[PhotoBuilder alloc] build];
    id photo2 = [[PhotoBuilder alloc] build];
    NSArray*photos = @[photo1,photo2];
    Restaurant *restaurant = [[[[RestaurantBuilder alloc] withReview:rating] withPhotos:photos] build];
    [_ctrl setRestaurant:restaurant];
    [self showView];

    // first page is displayed (summary & photo 1)
    NotebookPageHostViewController *nextController = _ctrl.viewControllers[0];
    assertThat(nextController.class, is(equalTo(RestaurantReviewSummaryViewController.class)));
    assertThat(((RestaurantReviewSummaryViewController *) nextController).restaurant, is(equalTo(restaurant)));
    assertThatInt(nextController.pageMode, is(equalTo(@(NotebookPageModeSmall))));
    // go to next page (review)
    nextController = [self viewControllerAfterViewController:nextController];
    assertThat(nextController.class, is(RestaurantReviewCommentViewController.class));
    assertThat(((RestaurantReviewCommentViewController *) nextController).review, is(equalTo(review)));
    assertThatInt(nextController.pageMode, is(equalTo(@(NotebookPageModeSmall))));
    // go to next page (photo 2)
    nextController = [self viewControllerAfterViewController:nextController];
    assertThat(nextController.class, is(RestaurantPhotoViewController.class));
    assertThat(((RestaurantPhotoViewController *) nextController).photo, is(equalTo(photo2)));
    assertThatInt(nextController.pageMode, is(equalTo(@(NotebookPageModeSmall))));
    // go to next page (which doesn't exist)
    nextController = [self viewControllerAfterViewController:nextController];
    assertThat(nextController, is(nilValue()));
    // go to prev page (review)
    nextController = [self viewControllerBeforeViewController:nextController];
    assertThat(nextController.class, is(RestaurantReviewCommentViewController.class));
    assertThat(((RestaurantReviewCommentViewController *) nextController).review, is(equalTo(review)));
    assertThatInt(nextController.pageMode, is(equalTo(@(NotebookPageModeSmall))));
    // go to prev controller (summary)
    nextController = [self viewControllerBeforeViewController:nextController];
    assertThat(nextController.class, is(equalTo(RestaurantReviewSummaryViewController.class)));
    assertThat(((RestaurantReviewSummaryViewController *) nextController).restaurant, is(equalTo(restaurant)));
    assertThatInt(nextController.pageMode, is(equalTo(@(NotebookPageModeSmall))));
    // go to prev controller (which doesn't exists)
    nextController = [self viewControllerBeforeViewController:nextController];
    assertThat(nextController, is(nilValue()));
}


-(void)test_createCloneOfCurrentlyVisibleControllerForEnlargedView_ShouldDoWhatMethodDescribes{
    // Summary, Review and Photo (3 Controllers)
    RestaurantReview *review = [self review:@"Good food"];
    RestaurantRating *rating = [self rating:@[ review]];
    id photo1 = [[PhotoBuilder alloc] build];
    id photo2 = [[PhotoBuilder alloc] build];
    NSArray*photos = @[photo1,photo2];
    Restaurant *restaurant = [[[[RestaurantBuilder alloc] withReview:rating] withPhotos:photos] build];
    [_ctrl setRestaurant:restaurant];
    [self showView];

    // Summary view is displayed
    UIViewController *currentController = _ctrl.viewControllers[0];
    UIViewController <INotebookPageHostViewController> *clone = [_ctrl createCloneOfCurrentlyVisibleControllerForEnlargedView];
    assertThat(clone.class, is(equalTo(RestaurantReviewSummaryViewController.class)));
    assertThat(((RestaurantReviewSummaryViewController *) clone).restaurant, is(equalTo(restaurant)));
    assertThat(clone, isNot(sameInstance(currentController)));
    assertThatInt(clone.pageMode, is(equalTo(@(NotebookPageModeLarge))));

    currentController = [_ctrl pageViewController:_ctrl viewControllerAfterViewController:currentController];
    // Comment view is displayed
    clone = [_ctrl createCloneOfCurrentlyVisibleControllerForEnlargedView];
    assertThat(clone.class, is(equalTo(RestaurantReviewCommentViewController.class)));
    assertThat(((RestaurantReviewCommentViewController *) clone).review, is(equalTo(review)));
    assertThat(clone, isNot(sameInstance(currentController)));
    assertThatInt(clone.pageMode, is(equalTo(@(NotebookPageModeLarge))));

    currentController = [_ctrl pageViewController:_ctrl viewControllerAfterViewController:currentController];
    // Photo view is displayed
    clone = [_ctrl createCloneOfCurrentlyVisibleControllerForEnlargedView];
    assertThat(clone.class, is(equalTo(RestaurantPhotoViewController.class)));
    assertThat(((RestaurantPhotoViewController *) clone).photo, is(equalTo(photo2)));
    assertThat(clone, isNot(sameInstance(currentController)));
    assertThatInt(clone.pageMode, is(equalTo(@(NotebookPageModeLarge))));
}


@end
