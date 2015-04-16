//
// Created by Jorg on 07/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotebookPageHostViewController.h"
#import "IPhoto.h"
#import "ISchedulerFactory.h"


@interface RestaurantPhotoViewController : NotebookPageHostViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic) id <IPhoto> photo;

- (void)setSchedulerFactory:(id <ISchedulerFactory>)schedulerFactory;
@end