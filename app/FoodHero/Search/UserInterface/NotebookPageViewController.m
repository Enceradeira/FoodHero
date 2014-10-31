//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "NotebookPageViewController.h"
#import "FoodHeroColors.h"


@implementation NotebookPageViewController {

    __weak IBOutlet UIImageView *_notebookColumnsView;
    __weak IBOutlet NSLayoutConstraint *_notebookPageLeftConstraint;
    __weak IBOutlet UIView *_notebookPageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // have the _notebookPageView start where the _notebookColumnsView end
    _notebookPageLeftConstraint.constant = _notebookColumnsView.image.size.width;

    _notebookPageView.backgroundColor = [FoodHeroColors yellowColor];

    // _notebookPage with drop-shadow
    CALayer *layer = _notebookPageView.layer;
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(3.0f, 2.0f);
    layer.shadowOpacity = 0.3f;
}


@end