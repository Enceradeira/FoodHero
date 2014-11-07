//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewSummaryViewController.h"
#import "RatingStarsImageRepository.h"
#import "IPhoto.h"


@implementation RestaurantReviewSummaryViewController {
    __weak IBOutlet NSLayoutConstraint *leftBorderConstraint;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    leftBorderConstraint.constant = leftBorderConstraint.constant + [self notebookPaddingLeft];

    [self bind];
}

- (void)bind {
    RestaurantRating *rating = _restaurant.rating;

    self.ratingImage.image = [RatingStarsImageRepository getImageForRating:rating.rating].image;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", rating.rating];
    self.ratingLabel.accessibilityIdentifier = @"ReviewSummary";

    UIImage *image = nil;
    if (_restaurant.photos.count > 0) {
        id<IPhoto> photo = _restaurant.photos[0];
        CGSize photoSize = self.photoView.bounds.size;
        NSURL *url = [NSURL URLWithString:[photo getUrlForHeight:(NSUInteger) photoSize.height andWidth:(NSUInteger) photoSize.width]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [[UIImage alloc] initWithData:data];
    }
    self.photoView.image = image;
}

- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
    [self bind];
}
@end