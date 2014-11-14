//
// Created by Jorg on 14/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "LargeRestaurantReviewCommentViewController.h"


@implementation LargeRestaurantReviewCommentViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self bind];
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

- (void)setReview:(RestaurantReview *)review {
    _review = review;
    [self bind];
}

- (void)bind {
    [RestaurantReviewCommentViewBinder writeReview:_review toView:self];
}


@end