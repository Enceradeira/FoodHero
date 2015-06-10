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
#import "RestaurantReviewBuilder.h"
#import "RatingStarsImageRepository.h"

@interface LargeRestaurantReviewCommentViewControllerTests : XCTestCase

@end

@implementation LargeRestaurantReviewCommentViewControllerTests {
    LargeRestaurantReviewCommentViewController *_ctrl;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly assembly]];
    _ctrl = [ControllerFactory createLargeRestaurantReviewCommentViewController];

    [_ctrl setReview:[[[[[[RestaurantReviewBuilder alloc] withText:@"Nice location"] withRating:2.5] withAuthor:@"John Wayne"] date:[NSDate date]] build]];
    _ctrl.view.hidden = NO;
}

- (void)test_summaryLabel_ShouldContainSummary {
    assertThat(_ctrl.reviewTextView.text, is(equalTo(@"Nice location")));
}

- (void)test_ratingLabel_ShouldContainRating {
    assertThat(_ctrl.ratingLabel.text, is(equalTo(@"2.5")));
}

- (void)test_ratingImage_ShouldContainRatingImage {
    UIImage *image = [RatingStarsImageRepository getImageForRating:2.5].image;

    assertThat(_ctrl.ratingImage.image, is(equalTo(image)));
}

- (void)test_signatureLabelLabel_ShouldContainSignature {
    assertThat(_ctrl.signatureLabel.text, is(equalTo(@"0 seconds ago by John Wayne")));
}

@end
