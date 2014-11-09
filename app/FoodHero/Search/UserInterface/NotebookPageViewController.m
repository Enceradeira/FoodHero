//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "NotebookPageViewController.h"
#import "FoodHeroColors.h"
#import "NotebookBackgroundConfigurator.h"


@implementation NotebookPageViewController {

    __weak IBOutlet UIImageView *_notebookColumnsView;
    __weak IBOutlet NSLayoutConstraint *_notebookPageLeftConstraint;
    __weak IBOutlet UIView *_notebookPageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // have the _notebookPageView start where the _notebookColumnsView end
    _notebookPageLeftConstraint.constant = _notebookColumnsView.image.size.width;

    [NotebookBackgroundConfigurator configure:_notebookPageView];
}


- (CGFloat)paddingLeft {
    return _notebookPageLeftConstraint.constant;
}
@end