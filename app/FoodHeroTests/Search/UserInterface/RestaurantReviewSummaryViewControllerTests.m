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
#import "PhotoBuilder.h"

@interface RestaurantReviewSummaryViewControllerTests : XCTestCase

@end

@implementation RestaurantReviewSummaryViewControllerTests {
    RestaurantReviewSummaryViewController *_ctrl;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly assembly]];
    _ctrl = [ControllerFactory createRestaurantReviewSummaryViewController];
    [_ctrl embedNotebookWith:NotebookPageModeSmall];
    _ctrl.view.hidden = NO;
}


- (void)test_ratingLabel_ShouldContainRating {
    RestaurantRating *rating = [[[[RestaurantRatingBuilder alloc] withRating:3.2] withReviews:@[]] build];
    [_ctrl setRestaurant:[[[RestaurantBuilder alloc] withReview:rating] build]];

    assertThat(_ctrl.ratingLabel.text, is(equalTo(@"3.2")));
}

- (void)test_ratingImage_ShouldContainRatingImage {
    NSArray *reviews = @[[[[RestaurantReviewBuilder alloc] withText:@"Nice location"] build]];
    RestaurantRating *rating = [[[[RestaurantRatingBuilder alloc] withRating:3.2] withReviews:reviews] build];
    [_ctrl setRestaurant:[[[RestaurantBuilder alloc] withReview:rating] build]];

    UIImage *image = [RatingStarsImageRepository getImageForRating:3].image;
    assertThat(_ctrl.ratingImage.image, is(equalTo(image)));
}

- (void)test_imageView_ShouldDisplayImage {
    id photo = [[PhotoBuilder alloc] build];

    [_ctrl setRestaurant:[[[RestaurantBuilder alloc] withPhotos:@[photo]] build]];

    assertThat(_ctrl.photoView.image, is(notNilValue()));
}

- (void)test_imageView_ShouldBeNil_WhenNoPhotosAvailable {
    [_ctrl setRestaurant:[[[RestaurantBuilder alloc] withPhotos:@[]] build]];

    assertThat(_ctrl.photoView.image, is(nilValue()));
}

-(void)test_embedNotebookWith_ShouldNotCrash{
    [_ctrl embedNotebookWith:NotebookPageModeSmall];
}
@end
