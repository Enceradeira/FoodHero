//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantReview.h"
#import "NotebookPageHostViewController.h"
#import "IRestaurantReviewCommentViewController.h"
#import "RestaurantReviewCommentViewBinder.h"

@interface SmallRestaurantReviewCommentViewController : NotebookPageHostViewController<IRestaurantReviewCommentViewController>
@property(weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property(weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property(weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property(weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property(nonatomic) RestaurantReview *review;
@end