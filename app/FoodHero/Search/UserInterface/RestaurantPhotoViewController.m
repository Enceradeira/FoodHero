//
// Created by Jorg on 07/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantPhotoViewController.h"
#import "TyphoonComponents.h"
#import "ISchedulerFactory.h"


@implementation RestaurantPhotoViewController {

    __weak IBOutlet NSLayoutConstraint *leftBorderConstraint;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    leftBorderConstraint.constant = leftBorderConstraint.constant + [self notebookPaddingLeft];

    [self bind];
}

- (void)bind {
    id <ISchedulerFactory> schedulerFactory = [(id <ApplicationAssembly>) [TyphoonComponents factory] schedulerFactory];
    RACScheduler *mainThreadScheduler = [schedulerFactory mainThreadScheduler];
    [[_photo.image deliverOn:mainThreadScheduler] subscribeNext:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (void)setPhoto:(id <IPhoto>)photo {
    _photo = photo;
    [self bind];
}
@end