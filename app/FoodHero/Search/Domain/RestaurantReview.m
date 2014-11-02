//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReview.h"


@implementation RestaurantReview {

}
+ (instancetype)create:(NSString *)review {
    return [[RestaurantReview alloc] init:review];
}

- (id)init:(NSString *)review {
    self = [super init];
    if( self){
        _text = review;
    }
    return self;
}
@end