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
    UIViewController <INotebookPageController> *_notebookController;
    NotebookPageMode _pageMode;
}

- (UIView *)getContainerView {
    @throw [DesignByContractException createWithReason:@"getContainerView must be overridden"];
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_pageMode == NotebookPageModeSmall) {
        // Display a notebook in background
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
}

- (RACSignal *)notebookPaddingLeft {
    if (!_notebookController) {
        return [RACSignal return:@(0.0)];
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