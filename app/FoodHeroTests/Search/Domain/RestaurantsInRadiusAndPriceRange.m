//
// Created by Jorg on 15/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantsInRadiusAndPriceRange.h"
#import "PriceRange.h"

@implementation RestaurantsInRadiusAndPriceRange {

}
+ (instancetype)restaurantsInRadius:(double)radius priceLevel:(NSUInteger)priceLevel restaurants:(NSArray *)restaurants {
    return [[RestaurantsInRadiusAndPriceRange alloc] initWithRadius:radius priceLevel:priceLevel restaurants:restaurants];
}

- (instancetype)initWithRadius:(double)radius priceLevel:(NSUInteger)priceLevel restaurants:(NSArray *)restaurants {
    self = [super init];
    if (self != nil) {
        _radius = radius;
        _restaurants = restaurants;
        _priceLevel = priceLevel;
    }
    return self;
}

+ (instancetype)restaurantsInRadius:(NSUInteger)radius restaurants:(NSArray *)restaurants {
    return [[RestaurantsInRadiusAndPriceRange alloc] initWithRadius:radius priceLevel:GOOGLE_PRICE_LEVEL_MIN restaurants:restaurants];
}

@end