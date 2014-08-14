//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Place.h"


@implementation Place {

}
+ (instancetype)createWithPlaceId:(NSString *)placeId location:(CLLocation *)location {
    return [[Place alloc] initWithPlaceId:placeId location:location];
}

- (instancetype)initWithPlaceId:(NSString *)placeId location:(CLLocation *)location {
    self = [super init];
    if (self != nil) {
        _placeId = placeId;
        _location = location;
    }
    return self;
}

@end