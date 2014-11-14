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
#import "SmallRestaurantReviewCommentViewController.h"
#import "RestaurantReviewPageViewController.h"
#import "NotebookPageViewController.h"
#import "LargeRestaurantReviewCommentViewController.h"

@interface ControllerFactory : NSObject
+ (ConversationViewController *)createConversationViewController;

+ (RestaurantDetailTableViewController *)createRestaurantDetailTableViewController;

+ (OpeningHoursViewController *)createOpeningHoursViewController;

+ (RestaurantReviewSummaryViewController *)createRestaurantReviewSummaryViewController;

+ (SmallRestaurantReviewCommentViewController *)createSmallRestaurantReviewCommentViewController;

+ (RestaurantPhotoViewController *)createRestaurantPhotoViewController;

+ (RestaurantReviewPageViewController *)createRestaurantReviewPageViewController;

+ (NotebookPageViewController *)createNotebookPageViewController;

+ (LargeRestaurantReviewCommentViewController *)createLargeRestaurantReviewCommentViewController;
@end
