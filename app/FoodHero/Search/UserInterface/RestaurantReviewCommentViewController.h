//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantReview.h"
#import "NotebookPageHostViewController.h"


@interface RestaurantReviewCommentViewController : NotebookPageHostViewController
@property(nonatomic) RestaurantReview *review;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property(weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property(weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end