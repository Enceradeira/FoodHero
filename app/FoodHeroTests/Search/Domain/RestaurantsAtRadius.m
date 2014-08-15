//
// Created by Jorg on 15/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantsAtRadius.h"

@implementation RestaurantsAtRadius {

}
+ (instancetype)create:(double)radius restaurants:(NSArray *)restaurants {
    return [[RestaurantsAtRadius alloc] initWithRadius:radius restaurants:restaurants];
}

- (id)initWithRadius:(double)radius restaurants:(NSArray *)restaurants {
    self = [super init];
    if (self != nil) {
        _radius = radius;
        _restaurants = restaurants;
    }
    return self;
}

@end