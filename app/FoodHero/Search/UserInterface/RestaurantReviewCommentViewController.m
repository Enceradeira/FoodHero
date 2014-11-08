//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <SORelativeDateTransformer.h>
#import "RestaurantReviewCommentViewController.h"
#import "RatingStarsImageRepository.h"
#import "FoodHeroColors.h"


@implementation RestaurantReviewCommentViewController {

    __weak IBOutlet UIView *_containerView;
    __weak IBOutlet NSLayoutConstraint *leftBorderConstraint;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    leftBorderConstraint.constant = leftBorderConstraint.constant + [self notebookPaddingLeft];

    [self bind];
}

- (void)setReview:(RestaurantReview *)review {
    _review = review;

    [self bind];
}

- (void)bind {
    self.reviewLabel.text = _review.text;
    self.reviewLabel.accessibilityIdentifier = @"ReviewComment";
    self.reviewLabel.textColor = [FoodHeroColors darkGrey];

    self.ratingImage.image = [RatingStarsImageRepository getImageForRating:_review.rating].image;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", _review.rating];
    self.ratingLabel.textColor = [FoodHeroColors darkGrey];
    self.signatureLabel.text = [NSString stringWithFormat:@"%@ by %@", [self convertToRelativeDate:_review.date], _review.author];
    self.signatureLabel.textColor = [FoodHeroColors darkGrey];

    if (self.reviewLabel.font.pointSize < self.signatureLabel.font.pointSize) {
        // ensure that font of signature is never larger than of review text
        self.signatureLabel.font = self.reviewLabel.font;
    }
}

- (NSString *)convertToRelativeDate:(NSDate *)date {
    return [[SORelativeDateTransformer registeredTransformer] transformedValue:date];
}

- (UIView *)getContainerView {
    return _containerView;
}

@end