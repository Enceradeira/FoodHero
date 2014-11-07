//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "NotebookPageHostViewController.h"


@interface RestaurantReviewSummaryViewController : NotebookPageHostViewController
@property(weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property(weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property(nonatomic) Restaurant *restaurant;
@end