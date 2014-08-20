//
// Created by Jorg on 20/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Place.h"


@implementation Place {

}
- (instancetype)initWithPlaceId:(NSString *)placeId location:(CLLocation *)location priceLevel:(NSUInteger)priceLevel {
    self = [super initWithPlaceId:placeId location:location];
    if (self) {
        _priceLevel = priceLevel;
    }
    return self;
}

+ (instancetype)create:(NSString *)placeId location:(CLLocation *)location priceLevel:(NSUInteger)priceLevel {
    return [[Place alloc] initWithPlaceId:placeId location:location priceLevel:priceLevel];
}


@end