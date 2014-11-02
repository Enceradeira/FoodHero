//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewBuilder.h"


@implementation RestaurantReviewBuilder {

    NSString *_text;
}
- (RestaurantReview *)build {
    return [RestaurantReview create:_text ? @"Nice, cosy but expensive place" : _text];
}

- (RestaurantReviewBuilder *)withText:(NSString *)text {
    _text = text;
    return self;
}

@end