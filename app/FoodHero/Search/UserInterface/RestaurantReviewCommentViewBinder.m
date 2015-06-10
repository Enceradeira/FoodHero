//
// Created by Jorg on 14/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewCommentViewBinder.h"
#import "FoodHeroColors.h"
#import "RatingStarsImageRepository.h"


@implementation RestaurantReviewCommentViewBinder {
}

+ (NSString *)convertToRelativeDate:(NSDate *)date {
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    formatter.allowedUnits = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    formatter.maximumUnitCount = 1;
    return  [formatter stringFromDate:date toDate:[NSDate date]];
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

    signatureLabel.text = [NSString stringWithFormat:@"%@ ago by %@", [self convertToRelativeDate:review.date], review.author];
    signatureLabel.textColor = [FoodHeroColors darkGrey];
}

@end