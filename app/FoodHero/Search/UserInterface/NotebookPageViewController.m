//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "NotebookPageViewController.h"
#import "NotebookBackgroundConfigurator.h"


@implementation NotebookPageViewController {

    __weak IBOutlet UIImageView *_notebookColumnsView;
    __weak IBOutlet NSLayoutConstraint *_notebookPageLeftConstraint;
    __weak IBOutlet UIView *_notebookPageView;
    RACSubject *_paddingLeftSignal;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [NotebookBackgroundConfigurator configure:_notebookPageView];

    _paddingLeftSignal = [RACSubject new];
}

- (CGSize)aspectFitWithAspectRation:(CGSize)aspectRatio boundingSize:(CGSize)boundingSize {
    float mW = boundingSize.width / aspectRatio.width;
    float mH = boundingSize.height / aspectRatio.height;
    if (mH < mW)
        boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width;
    else if (mW < mH)
        boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height;
    return boundingSize;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    // have the _notebookPageView start where the _notebookColumnsView end
    CGSize realSize = [self aspectFitWithAspectRation:_notebookColumnsView.image.size boundingSize:_notebookColumnsView.frame.size];

    _notebookPageLeftConstraint.constant = realSize.width ;
    [_paddingLeftSignal sendNext:@(_notebookPageLeftConstraint.constant)];
}

- (RACSignal *)paddingLeft {
    return _paddingLeftSignal;
}
@end