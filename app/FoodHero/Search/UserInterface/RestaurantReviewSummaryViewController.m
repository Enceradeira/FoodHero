//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewSummaryViewController.h"
#import "RatingStarsImageRepository.h"
#import "IPhoto.h"
#import "FoodHeroColors.h"
#import "TyphoonComponents.h"
#import "ISchedulerFactory.h"


@implementation RestaurantReviewSummaryViewController {
    __weak IBOutlet NSLayoutConstraint *leftBorderConstraint;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    leftBorderConstraint.constant = leftBorderConstraint.constant + [self notebookPaddingLeft];
    self.ratingLabel.accessibilityIdentifier = @"ReviewSummary";
    self.ratingLabel.textColor = [FoodHeroColors darkGrey];

    [self bind];
}

- (void)bind {
    RestaurantRating *rating = _restaurant.rating;

    self.ratingImage.image = [RatingStarsImageRepository getImageForRating:rating.rating].image;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", rating.rating];

    if (_restaurant.photos.count > 0) {
        id<ISchedulerFactory> schedulerFactory = [(id <ApplicationAssembly>) [TyphoonComponents factory] schedulerFactory];
        RACScheduler *mainThreadScheduler = [schedulerFactory mainThreadScheduler];

        id <IPhoto> photo = _restaurant.photos[0];
        [[photo.image deliverOn:mainThreadScheduler] subscribeNext:^(UIImage *image) {
            self.photoView.image = image;
        }];
    }
}

- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
    [self bind];
}
@end