//
//  RatingStarsImageRepositoryTests.m
//  FoodHero
//
//  Created by Jorg on 02/11/14.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest.h>
#import "RatingStarsImageRepository.h"

@interface RatingStarsImageRepositoryTests : XCTestCase

@end

@implementation RatingStarsImageRepositoryTests

- (void)assertThat:(RatingStarsImage *)image isForRating:(NSString *)rating {
    assertThat(image, is(notNilValue()));
    assertThat(image.image, is(notNilValue()));
    assertThat(image.name, containsString(rating));
}

- (void)test_rating_ShouldReturn0Stars_WhenRatingSmallerThan0 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:-0.8];
    [self assertThat:image isForRating:@"0.0"];
}


- (void)test_rating_ShouldReturn0Stars_WhenRating0 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:0];
    [self assertThat:image isForRating:@"0.0"];
}

- (void)test_rating_ShouldReturn0Stars_WhenRating0_24 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:0.24];
    [self assertThat:image isForRating:@"0.0"];
}

- (void)test_rating_ShouldReturn0_5Stars_WhenRating0_25 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:0.25];
    [self assertThat:image isForRating:@"0.5"];
}

- (void)test_rating_ShouldReturn0_5Stars_WhenRating0_74 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:0.74];
    [self assertThat:image isForRating:@"0.5"];
}

- (void)test_rating_ShouldReturn1_0Stars_WhenRating0_75 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:0.75];
    [self assertThat:image isForRating:@"1.0"];
}

- (void)test_rating_ShouldReturn1_5Stars_WhenRating1_5 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:1.5];
    [self assertThat:image isForRating:@"1.5"];
}

- (void)test_rating_ShouldReturn2Stars_WhenRating2_2 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:2.2];
    [self assertThat:image isForRating:@"2.0"];
}

- (void)test_rating_ShouldReturn2_5Stars_WhenRating2_6 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:2.6];
    [self assertThat:image isForRating:@"2.5"];
}

- (void)test_rating_ShouldReturn3Stars_WhenRating3 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:3];
    [self assertThat:image isForRating:@"3.0"];
}

- (void)test_rating_ShouldReturn3_5Stars_WhenRating3_487 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:3.487];
    [self assertThat:image isForRating:@"3.5"];
}

- (void)test_rating_ShouldReturn4Stars_WhenRating4_1 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:4.1];
    [self assertThat:image isForRating:@"4.0"];
}

- (void)test_rating_ShouldReturn4_5Stars_WhenRating4_74 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:4.74];
    [self assertThat:image isForRating:@"4.5"];
}

- (void)test_rating_ShouldReturn5Stars_WhenRating5 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:5.0];
    [self assertThat:image isForRating:@"5.0"];
}

- (void)test_rating_ShouldReturn5Stars_WhenRatingGreateThan5 {
    RatingStarsImage *image = [RatingStarsImageRepository getImageForRating:15.0];
    [self assertThat:image isForRating:@"5.0"];
}


@end
