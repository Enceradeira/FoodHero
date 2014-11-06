//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantRating.h"


@interface RestaurantReviewSummaryViewController : UIViewController
@property(weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property(weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property(weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property(nonatomic) RestaurantRating *rating;
@end