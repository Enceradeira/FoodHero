//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewPageViewController.h"
#import "TyphoonComponents.h"
#import "Restaurant.h"


@implementation RestaurantReviewPageViewController {

    id _summaryController;
    id _commentController;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = self;
    _summaryController = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"NotebookPageViewController"];
    _commentController = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"RestaurantReviewCommentViewController"];;


    NSArray *controllers = @[_summaryController];
    [self setViewControllers:controllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}



- (void)setRestaurant:(Restaurant *)restaurant {

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return _summaryController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return _commentController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}


@end