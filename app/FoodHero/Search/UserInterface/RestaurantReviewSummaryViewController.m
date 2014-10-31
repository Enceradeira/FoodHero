//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewSummaryViewController.h"


@implementation RestaurantReviewSummaryViewController {

    __weak IBOutlet UIImageView *backgroundView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *image = [[UIImage imageNamed:@"Notebook.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 40, 0, 0) resizingMode:UIImageResizingModeStretch];

    backgroundView.contentMode =  UIViewContentModeLeft;
    backgroundView.image = image;
}


@end