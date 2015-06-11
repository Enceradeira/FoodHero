//
// Created by Jorg on 09/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "LargeRestaurantReviewViewController.h"
#import "FoodHeroColors.h"
#import "NotebookBackgroundConfigurator.h"
#import "FoodHero-Swift.h"


@implementation LargeRestaurantReviewViewController {

    __weak IBOutlet UIView *_backgroundView;
    __weak IBOutlet UIView *_containerView;
    UIViewController *_containerContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [GAIService logScreenViewed:@"Restaurant Review Large"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addChildViewController:_containerContent];

    UIView *controllerView = _containerContent.view;

    // controllerView which becomes the container content, should not resize because we control resizing with constraints
    [controllerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    // controllerView which becomes the container content, should be transparent in order that we see the background behind
    controllerView.backgroundColor = [UIColor clearColor];
    [_containerView addSubview:controllerView];
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:controllerView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:controllerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:controllerView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:controllerView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

    [_containerContent didMoveToParentViewController:self];

    [NotebookBackgroundConfigurator configure:_backgroundView];
}


- (void)addContent:(UIViewController *)controller {
    _containerContent = controller;

}
@end