//
// Created by Jorg on 08/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "LargeNotebookPageViewController.h"
#import "FoodHeroColors.h"


@implementation LargeNotebookPageViewController {

    __weak IBOutlet UIView *_notebookPageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _notebookPageView.backgroundColor = [FoodHeroColors yellowColor];

    // _notebookPage with drop-shadow
    _notebookPageView.layer.masksToBounds = NO;
    _notebookPageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _notebookPageView.layer.shadowOffset = CGSizeMake(3.0f, 2.0f);
    _notebookPageView.layer.shadowOpacity = 0.3f;

    // _notebookPage with round corners
    _notebookPageView.layer.cornerRadius = 8.0f;
}

- (CGFloat)paddingLeft {
    return 0;
}


@end