//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewCommentViewController.h"
#import "RatingStarsImageRepository.h"


@implementation RestaurantReviewCommentViewController {

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
    _reviewLabel.text = _review.text;
    _reviewLabel.accessibilityIdentifier = @"ReviewComment";

    self.ratingImage.image = [RatingStarsImageRepository getImageForRating:_review.rating].image;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", _review.rating];
    self.signatureLabel.text = [NSString stringWithFormat:@"%@ by %@", [self convertToRelativeDate:_review.date], _review.author];
}

- (NSString *)convertToRelativeDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.doesRelativeDateFormatting = YES;
    return [dateFormatter stringFromDate:date];
}


@end