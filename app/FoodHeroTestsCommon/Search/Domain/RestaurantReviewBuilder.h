//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantReview.h"


@interface RestaurantReviewBuilder : NSObject
- (RestaurantReview *)build;

- (RestaurantReviewBuilder *)withText:(NSString *)text;
@end