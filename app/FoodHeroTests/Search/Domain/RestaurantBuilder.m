//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantBuilder.h"


@implementation RestaurantBuilder {

    NSString *_name;
    NSString *_vicinity;
    CLLocation *_location;
    NSUInteger _priceLevel;
    BOOL _priceLevelSet;
    NSUInteger _cuisineRelevance;
}

- (Restaurant *)build {

    NSString *name = _name == nil ? @"Raj Palace" : _name;
    NSString *vicinity = _vicinity == nil ? @"18 Cathedral Street, Norwich" : _vicinity;
    CLLocation *location = _location == nil ? [[CLLocation alloc] initWithLatitude:45.88879 longitude:1.55668] : _location;
    NSUInteger priceLevel = _priceLevelSet ? _priceLevel : 2;
    NSUInteger cuisineRelevance = _cuisineRelevance == 0 ? 89 : _cuisineRelevance;
    return [Restaurant createWithName:name vicinity:vicinity types:@[@"restaurant"] placeId:[[NSUUID UUID] UUIDString] location:location priceLevel:priceLevel cuisineRelevance:cuisineRelevance];
}

- (RestaurantBuilder *)withName:(NSString *)name {
    _name = name;
    return self;
}

- (RestaurantBuilder *)withVicinity:(NSString *)vicinity {
    _vicinity = vicinity;
    return self;
}

- (RestaurantBuilder *)withLocation:(CLLocation *)location {
    _location = location;
    return self;
}

- (RestaurantBuilder *)withPriceLevel:(NSUInteger)priceLevel {
    _priceLevel = priceLevel;
    _priceLevelSet = YES;
    return self;
}

- (RestaurantBuilder *)withCuisineRelevance:(NSUInteger)cuisineRelevance {
    _cuisineRelevance = cuisineRelevance;
    return self;
}

@end