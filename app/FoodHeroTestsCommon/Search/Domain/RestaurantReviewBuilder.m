//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewBuilder.h"


@implementation RestaurantReviewBuilder {

    NSString *_text;
    double _rating;
    NSString *_author;
    NSDate *_date;
}
- (RestaurantReview *)build {
    NSString *text = !_text ? @"Nice, cosy but expensive place" : _text;
    NSString *author = _author == nil ? @"Franzl Meyer" : _author;
    NSDate *date = _date == nil ? [NSDate date] : _date;
    return [RestaurantReview create:text rating:_rating author:author date:date];
}

- (RestaurantReviewBuilder *)withText:(NSString *)text {
    _text = text;
    return self;
}

- (RestaurantReviewBuilder *)withRating:(double)rating {
    _rating = rating;
    return self;
}

- (RestaurantReviewBuilder *)withAuthor:(NSString *)name {
    _author = name;
    return self;
}

- (RestaurantReviewBuilder *)date:(NSDate *)date {
    _date = date;
    return self;
}
@end