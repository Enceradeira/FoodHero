//
// Created by Jorg on 03/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantDetailViewController.h"
#import "Restaurant.h"
#import "ControllerFactory.h"
#import "DesignByContractException.h"


@implementation RestaurantDetailViewController {

    __weak IBOutlet UIView *_detailView;
    __weak IBOutlet UIView *_reviewView;
    Restaurant *_restaurant;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reviewViewTapped:)];
    [_reviewView addGestureRecognizer:tapGesture];

}

- (void)reviewViewTapped:(id)reviewViewTapped {
    UIViewController* ctrl = [self.pageViewController createCloneOfCurrentlyVisibleControllerForEnlargedView];
    ctrl.navigationItem.backBarButtonItem.title = @"Restaurant";
    [self.navigationController pushViewController:ctrl animated:YES];
}


- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id <RestaurantController> controller = segue.destinationViewController;

    [controller setRestaurant:_restaurant];
    [super prepareForSegue:segue sender:sender];
}

- (RestaurantReviewPageViewController *)pageViewController {
    NSArray *results = [self.childViewControllers linq_where:^(UIViewController *c) {
        return [c isKindOfClass:RestaurantReviewPageViewController.class];
    }];
    if (results.count == 1) {
        return results[0];
    }
    else {
        @throw [DesignByContractException createWithReason:@"RestaurantReviewPageViewController not found"];
    }
}

@end