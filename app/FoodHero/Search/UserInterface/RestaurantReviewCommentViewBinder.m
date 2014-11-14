//
// Created by Jorg on 14/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewCommentViewBinder.h"
#import "SORelativeDateTransformer.h"
#import "FoodHeroColors.h"
#import "RatingStarsImageRepository.h"


@implementation RestaurantReviewCommentViewBinder {
}

+ (NSString *)convertToRelativeDate:(NSDate *)date {
    return [[SORelativeDateTransformer registeredTransformer] transformedValue:date];
}

+ (void)writeReview:(RestaurantReview *)review toView:(id <IRestaurantReviewCommentViewController>)controller {
    id <IUITextVisualizer> reviewLabel = controller.getReviewLabel;
    UIImageView *ratingImage = controller.getRatingImage;
    UILabel *ratingLabel = controller.getRatingLabel;
    UILabel *signatureLabel = controller.getSignatureLabel;

    [reviewLabel setText:review.text];
    [reviewLabel setAccessibilityIdentifier:@"ReviewComment"];
    [reviewLabel setTextColor:[FoodHeroColors darkGrey]];
    ratingImage.image = [RatingStarsImageRepository getImageForRating:review.rating].image;

    ratingLabel.text = [NSString stringWithFormat:@"%.1f", review.rating];
    ratingLabel.textColor = [FoodHeroColors darkGrey];

    signatureLabel.text = [NSString stringWithFormat:@"%@ by %@", [self convertToRelativeDate:review.date], review.author];
    signatureLabel.textColor = [FoodHeroColors darkGrey];
}

@end