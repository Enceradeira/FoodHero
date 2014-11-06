//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewSummaryViewController.h"
#import "Restaurant.h"
#import "RatingStarsImageRepository.h"
#import "NotebookPageViewController.h"
#import "DesignByContractException.h"


@implementation RestaurantReviewSummaryViewController {
    RestaurantRating *_rating;
    __weak IBOutlet NSLayoutConstraint *leftBorderConstraint;
    NotebookPageViewController *_notebookController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if( !_notebookController ){
        @throw [DesignByContractException createWithReason:@"NotebookController was not found in prepareForSeque"];
    }

    leftBorderConstraint.constant = leftBorderConstraint.constant + _notebookController.paddingLeft;

    [self bind];
}

- (void)bind {
    self.ratingImage.image = [RatingStarsImageRepository getImageForRating:_rating.rating].image;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", _rating.rating];
    self.summaryLabel.text = _rating.summary.text;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"Container"]) {
        _notebookController = (NotebookPageViewController *)[segue destinationViewController];
    }
}

- (void)setRating:(RestaurantRating *)rating {
    _rating = rating;
    [self bind];
}
@end