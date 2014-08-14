//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Place.h"


@implementation Place {

}
+ (instancetype)createWithPlaceId:(NSString *)placeId {
    return [[Place alloc] initWithPlaceId:placeId];
}

- (instancetype)initWithPlaceId:(NSString *)placeId {
    self = [super init];
    if (self != nil) {
        _placeId = placeId;
    }
    return self;
}

@end