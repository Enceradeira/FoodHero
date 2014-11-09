//
//  ControllerFactory.h
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Typhoon.h>
#import "ConversationViewController.h"
#import "RestaurantPhotoViewController.h"
#import "OpeningHoursViewController.h"
#import "RestaurantDetailTableViewController.h"
#import "RestaurantReviewSummaryViewController.h"
#import "RestaurantReviewCommentViewController.h"
#import "RestaurantReviewPageViewController.h"
#import "NotebookPageViewController.h"

@interface ControllerFactory : NSObject
+ (ConversationViewController *)createConversationViewController;

+ (RestaurantDetailTableViewController *)createRestaurantDetailTableViewController;

+ (OpeningHoursViewController *)createOpeningHoursViewController;

+ (RestaurantReviewSummaryViewController *)createRestaurantReviewSummaryViewController;

+ (RestaurantReviewCommentViewController *)createRestaurantReviewCommentViewController;

+ (RestaurantPhotoViewController *)createRestaurantPhotoViewController;

+ (RestaurantReviewPageViewController *)createRestaurantReviewPageViewController;

+ (NotebookPageViewController *)createNotebookPageViewController;
@end
