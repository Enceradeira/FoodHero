//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewSummaryViewController.h"
#import "RatingStarsImageRepository.h"


@implementation RestaurantReviewSummaryViewController {
    RestaurantRating *_rating;
    __weak IBOutlet NSLayoutConstraint *leftBorderConstraint;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    leftBorderConstraint.constant = leftBorderConstraint.constant + [self notebookPaddingLeft];

    [self bind];
}

- (void)bind {
    self.ratingImage.image = [RatingStarsImageRepository getImageForRating:_rating.rating].image;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", _rating.rating];
    self.ratingLabel.accessibilityIdentifier =  @"ReviewSummary";
    self.summaryLabel.text = _rating.summary.text;
}

- (void)setRating:(RestaurantRating *)rating {
    _rating = rating;
    [self bind];
}
@end