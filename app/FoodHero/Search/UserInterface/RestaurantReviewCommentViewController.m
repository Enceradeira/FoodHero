//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewCommentViewController.h"


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
    _reviewLabel.accessibilityIdentifier =  @"ReviewComment";

}


@end