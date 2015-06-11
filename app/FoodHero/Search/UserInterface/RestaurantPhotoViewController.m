//
// Created by Jorg on 07/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantPhotoViewController.h"
#import "TyphoonComponents.h"
#import "ISchedulerFactory.h"
#import "FoodHero-Swift.h"


@implementation RestaurantPhotoViewController {

    __weak IBOutlet UIView *_containerView;
    __weak IBOutlet NSLayoutConstraint *leftBorderConstraint;
    id <ISchedulerFactory> _schedulerFactory;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    leftBorderConstraint.constant = leftBorderConstraint.constant + [self notebookPaddingLeft];

    [self bind];
}

- (void)viewDidAppear:(BOOL)animated {
    [GAIService logScreenViewed:@"Restaurant Photo Small"];
}

-(void)setSchedulerFactory:(id <ISchedulerFactory>)schedulerFactory{
    _schedulerFactory = schedulerFactory;
}

- (void)bind {
    RACScheduler *mainThreadScheduler = [_schedulerFactory mainThreadScheduler];
    [[_photo.image deliverOn:mainThreadScheduler] subscribeNext:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (void)setPhoto:(id <IPhoto>)photo {
    _photo = photo;
    [self bind];
}

- (UIView *)getContainerView {
    return _containerView;
}


@end