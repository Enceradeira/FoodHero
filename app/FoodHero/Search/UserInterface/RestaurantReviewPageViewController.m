//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewPageViewController.h"
#import "TyphoonComponents.h"
#import "RestaurantReviewSummaryViewController.h"
#import "RestaurantReviewCommentViewController.h"


@implementation RestaurantReviewPageViewController {
    Restaurant *_restaurant;
    NSUInteger _index;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = self;

    NSArray *controllers = @[[self createSummaryController]];
    [self setViewControllers:controllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    _index = 0;
}

- (RestaurantReviewSummaryViewController *)createSummaryController {
    RestaurantReviewSummaryViewController *summaryController = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"RestaurantReviewSummaryViewController"];
    [summaryController setRestaurant:_restaurant];
    return summaryController;
}


- (RestaurantReviewCommentViewController *)createCommentControllerFor:(RestaurantReview *)review {
    RestaurantReviewCommentViewController *commentController = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"RestaurantReviewCommentViewController"];
    [commentController setReview:review];
    return commentController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (_index == 0) {
        return nil;
    }
    if (_index == 1) {
        _index--;
        return [self createSummaryController];
    }
    else {
        _index--;
        return [self createCommentControllerFor:_restaurant.rating.reviews[_index - 1]];
    }
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (_index < _restaurant.rating.reviews.count) {
        _index++;
        return [self createCommentControllerFor:_restaurant.rating.reviews[_index - 1]];
    }
    else {
        return nil;
    }
}

- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
}

/*
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    if (!_rating.summary) {
        return 0;
    }
    else {
        return _rating.reviews.count + 1;
    }
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
} */


@end