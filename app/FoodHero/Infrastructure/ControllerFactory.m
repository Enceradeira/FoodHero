//
//  ControllerFactory.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ControllerFactory.h"
#import "TyphoonComponents.h"
#import "NotebookPageViewController.h"
#import "LargeNotebookPageViewController.h"

@implementation ControllerFactory
+ (ConversationViewController *)createConversationViewController {
    TyphoonStoryboard *storyboard = [TyphoonComponents storyboard];

    return [storyboard instantiateViewControllerWithIdentifier:@"ConversationViewController"];
}

+ (RestaurantDetailTableViewController *)createRestaurantDetailTableViewController {
    TyphoonStoryboard *storyboard = [TyphoonComponents storyboard];

    return [storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailTableViewController"];
}

+ (OpeningHoursViewController *)createOpeningHoursViewController {
    TyphoonStoryboard *storyboard = [TyphoonComponents storyboard];

    return [storyboard instantiateViewControllerWithIdentifier:@"OpeningHoursViewController"];
}

+ (RestaurantReviewSummaryViewController *)createRestaurantReviewSummaryViewController {
    TyphoonStoryboard *storyboard = [TyphoonComponents storyboard];

    return [storyboard instantiateViewControllerWithIdentifier:@"RestaurantReviewSummaryViewController"];
}

+ (RestaurantReviewCommentViewController *)createRestaurantReviewCommentViewController {
    TyphoonStoryboard *storyboard = [TyphoonComponents storyboard];

    return [storyboard instantiateViewControllerWithIdentifier:@"RestaurantReviewCommentViewController"];
}

+ (RestaurantPhotoViewController *)createRestaurantPhotoViewController {
    TyphoonStoryboard *storyboard = [TyphoonComponents storyboard];

    return [storyboard instantiateViewControllerWithIdentifier:@"RestaurantPhotoViewController"];
}

+ (RestaurantReviewPageViewController *)createRestaurantReviewPageViewController {
    TyphoonStoryboard *storyboard = [TyphoonComponents storyboard];

    return [storyboard instantiateViewControllerWithIdentifier:@"RestaurantReviewPageViewController"];
}

+ (NotebookPageViewController *)createNotebookPageViewController {
    TyphoonStoryboard *storyboard = [TyphoonComponents storyboard];

    return [storyboard instantiateViewControllerWithIdentifier:@"NotebookPageViewController"];
}

+ (LargeNotebookPageViewController *)createLargeNotebookPageViewController {
    TyphoonStoryboard *storyboard = [TyphoonComponents storyboard];

    return [storyboard instantiateViewControllerWithIdentifier:@"LargeNotebookPageViewController"];
}
@end
