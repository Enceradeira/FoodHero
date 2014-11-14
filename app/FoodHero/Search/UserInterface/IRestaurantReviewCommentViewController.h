//
// Created by Jorg on 14/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantReview.h"

@protocol IRestaurantReviewCommentViewController <NSObject>
- (UILabel *)getReviewLabel;

- (UILabel *)getSignatureLabel;

- (UIImageView *)getRatingImage;

- (UILabel *)getRatingLabel;
@end