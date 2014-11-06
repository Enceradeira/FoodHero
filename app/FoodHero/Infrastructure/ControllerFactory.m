//
//  ControllerFactory.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ControllerFactory.h"
#import "TyphoonComponents.h"
#import "OpeningHoursViewController.h"
#import "RestaurantReviewSummaryViewController.h"
#import "RestaurantReviewPageViewController.h"

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

+ (RestaurantReviewPageViewController *)createRestaurantReviewPageViewController {
    TyphoonStoryboard *storyboard = [TyphoonComponents storyboard];

    return [storyboard instantiateViewControllerWithIdentifier:@"RestaurantReviewPageViewController"];
}
@end
