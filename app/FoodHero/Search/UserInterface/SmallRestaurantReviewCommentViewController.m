//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SmallRestaurantReviewCommentViewController.h"
#import "UILabelVisualizer.h"
#import "FoodHero-Swift.h"


@implementation SmallRestaurantReviewCommentViewController {

    __weak IBOutlet NSLayoutConstraint *_distanceRatingToReviewContstraint;
    __weak IBOutlet UIView *_containerView;
    __weak IBOutlet NSLayoutConstraint *leftBorderConstraint;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[[self notebookPaddingLeft] take:1] subscribeNext:^(NSNumber *paddingLeft ){
        leftBorderConstraint.constant = [paddingLeft floatValue];
    }];

    [self bind];
}

- (void)viewDidAppear:(BOOL)animated {
    [GAIService logScreenViewed:@"Restaurant Review Small"];
}

- (void)bind {
    [RestaurantReviewCommentViewBinder writeReview:_review toView:self];

    if (self.reviewLabel.font.pointSize < self.signatureLabel.font.pointSize) {
        // ensure that font of signature is never larger than of review text
        self.signatureLabel.font = self.reviewLabel.font;
    }
}

- (id <IUITextVisualizer>)getReviewLabel {
    return [UILabelVisualizer create:self.reviewLabel];
}

- (UILabel *)getSignatureLabel {
    return self.signatureLabel;
}

- (UIImageView *)getRatingImage {
    return self.ratingImage;
}

- (UILabel *)getRatingLabel {
    return self.ratingLabel;
}


- (UIView *)getContainerView {
    return _containerView;
}

- (void)setReview:(RestaurantReview *)review {
    _review = review;
    [self bind];
}

@end