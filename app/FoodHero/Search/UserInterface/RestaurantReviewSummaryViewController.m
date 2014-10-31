//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewSummaryViewController.h"
#import "FoodHeroColors.h"


@implementation RestaurantReviewSummaryViewController {

    __weak IBOutlet UIImageView *_notebookColumnsView;
    __weak IBOutlet NSLayoutConstraint *_notebookPageLeftConstraint;
    __weak IBOutlet UIView *_notebookPageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // have the _notebookPageView start where the _notebookColumnsView end
    _notebookPageLeftConstraint.constant = _notebookColumnsView.image.size.width;

    _notebookPageView.backgroundColor = [FoodHeroColors yellowColor];
}


@end