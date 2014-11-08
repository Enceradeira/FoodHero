//
// Created by Jorg on 06/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "NotebookPageHostViewController.h"
#import "DesignByContractException.h"
#import "NotebookPageViewController.h"
#import "ControllerFactory.h"


@implementation NotebookPageHostViewController {

    __weak IBOutlet NSLayoutConstraint *leftBorderConstraint;
    NotebookPageViewController *_notebookController;
    NotebookPageMode _pageMode;
}

- (UIView *)getContainerView {
    @throw [DesignByContractException createWithReason:@"getContainerView must be overridden"];
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _notebookController = [ControllerFactory createNotebookPageViewController];
    UIView *containerView = [self getContainerView];
    if (!containerView) {
        @throw [DesignByContractException createWithReason:@"no container-view returned"];
    }

    [self addChildViewController:_notebookController];
    _notebookController.view.frame = containerView.frame;
    [containerView addSubview:_notebookController.view];
    [_notebookController didMoveToParentViewController:self];
}


/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString:@"Container"]) {
        _notebookController = (NotebookPageViewController *) [segue destinationViewController];
    }
} */

- (CGFloat)notebookPaddingLeft {
    if (!_notebookController) {
        @throw [DesignByContractException createWithReason:@"NotebookController was not created using embedNotebookWith:"];
    }
    return _notebookController.paddingLeft;
}

- (void)embedNotebookWith:(NotebookPageMode)pageMode {
    _pageMode = pageMode;
}

- (NotebookPageMode)pageMode {
    return _pageMode;
}

@end