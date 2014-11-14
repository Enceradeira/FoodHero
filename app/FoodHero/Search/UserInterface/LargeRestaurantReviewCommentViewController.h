//
// Created by Jorg on 14/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRestaurantReviewCommentViewController.h"
#import "NotebookPageHostViewController.h"
#import "RestaurantReview.h"
#import "RestaurantReviewCommentViewBinder.h"


@interface LargeRestaurantReviewCommentViewController : UIViewController <IRestaurantReviewCommentViewController>
@property(weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property(weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property(weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property(weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property(nonatomic) RestaurantReview *review;
@end