//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SmallRestaurantReviewCommentViewController.h"


@implementation SmallRestaurantReviewCommentViewController {

    __weak IBOutlet NSLayoutConstraint *_distanceRatingToReviewContstraint;
    __weak IBOutlet UIView *_containerView;
    __weak IBOutlet NSLayoutConstraint *leftBorderConstraint;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    leftBorderConstraint.constant = leftBorderConstraint.constant + [self notebookPaddingLeft];

    [self bind];
}

- (void)bind {
    [RestaurantReviewCommentViewBinder writeReview:_review toView:self];

    if (self.reviewLabel.font.pointSize < self.signatureLabel.font.pointSize) {
        // ensure that font of signature is never larger than of review text
        self.signatureLabel.font = self.reviewLabel.font;
    }
}

- (UILabel *)getReviewLabel {
    return self.reviewLabel;
}

- (UILabel *)getSignatureLabel {
    return self.signatureLabel;
}

- (UIImageView *)getRatingImage {
    return self.ratingImage;
}

- (UILabel *)getRatingLabel {
    return self.ratingLabel;
}


- (UIView *)getContainerView {
    return _containerView;
}

- (void)setReview:(RestaurantReview *)review {
    _review = review;
    [self bind];
}

@end