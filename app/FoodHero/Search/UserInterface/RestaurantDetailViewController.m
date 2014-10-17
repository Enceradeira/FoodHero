//
// Created by Jorg on 03/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "Restaurant.h"


@implementation RestaurantDetailViewController {

    __weak IBOutlet UIView *_detailView;
    __weak IBOutlet UIView *_reviewView;
    Restaurant *_restaurant;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    }


- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id<RestaurantController> controller = segue.destinationViewController;

    [controller setRestaurant:_restaurant];
    [super prepareForSegue:segue sender:sender];
}

@end