//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantController.h"
#import "INotebookPageHostViewController.h"


@interface RestaurantReviewPageViewController : UIPageViewController <RestaurantController, UIPageViewControllerDataSource>
- (UIViewController *)createCloneOfCurrentlyVisibleControllerForEnlargedView;
@end