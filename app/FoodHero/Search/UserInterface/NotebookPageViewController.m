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
    _notebookPageView.layer.masksToBounds = NO;
    _notebookPageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _notebookPageView.layer.shadowOffset = CGSizeMake(3.0f, 2.0f);
    _notebookPageView.layer.shadowOpacity = 0.3f;

    // _notebookPage with round corners
    _notebookPageView.layer.cornerRadius = 8.0f;
}


- (CGFloat)paddingLeft {
    return _notebookPageLeftConstraint.constant;
}
@end