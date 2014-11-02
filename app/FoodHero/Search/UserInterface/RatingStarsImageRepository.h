//
// Created by Jorg on 02/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RatingStarsImage.h"


@interface RatingStarsImageRepository : NSObject
+ (RatingStarsImage *)getImageForRating:(double)rating;
@end