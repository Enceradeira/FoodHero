//
// Created by Jorg on 02/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RatingStarsImageRepository.h"


@implementation RatingStarsImageRepository {

}
+ (RatingStarsImage *)getImageForRating:(double)rating {

    double ratingRounded;
    if (rating < 0) {
        ratingRounded = 0;
    }
    else if (rating > 5) {
        ratingRounded = 5;
    }
    else {
        double ratingInt = floor(rating);
        double rest = rating - ratingInt;
        double ratingDec = 0;
        if (rest < 0.25) {
            ratingDec = 0;
        }
        else if (rest < 0.75) {
            ratingDec = 0.5;
        }
        else {
            ratingDec = 1;
        }
        ratingRounded = ratingInt + ratingDec;
    }
    NSString *name = [NSString stringWithFormat:@"rating-stars-%.1f@2x.png", ratingRounded];
    return [RatingStarsImage create:name];
}

@end