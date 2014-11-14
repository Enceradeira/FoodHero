//
// Created by Jorg on 14/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotebookPageHostViewController.h"
#import "IRestaurantReviewCommentViewController.h"

@interface RestaurantReviewCommentViewBinder : NSObject
+ (void)writeReview:(RestaurantReview *)review toView:(id <IRestaurantReviewCommentViewController>)controller;
@end