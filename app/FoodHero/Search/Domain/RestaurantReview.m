//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReview.h"


@implementation RestaurantReview {

}
+ (instancetype)create:(NSString *)review rating:(double)rating author:(NSString *)author date:(NSDate *)date {
    return [[RestaurantReview alloc] init:review rating:rating author:author date:date];
}

- (id)init:(NSString *)review rating:(double)rating author:(NSString *)author date:(NSDate *)date {
    self = [super init];
    if (self) {
        _text = review;
        _rating = rating;
        _author = author;
        _date = date;
    }
    return self;
}
@end