//
// Created by Jorg on 15/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PriceLevelRange;


@interface RestaurantsInRadiusAndPriceRange : NSObject
@property(nonatomic) double radius;
@property(nonatomic) NSArray *restaurants;
@property(nonatomic) NSUInteger priceLevel;

+ (instancetype)restaurantsInRadius:(double)radius priceLevel:(NSUInteger)priceLevel restaurants:(NSArray *)restaurants;

- (instancetype)initWithRadius:(double)radius priceLevel:(NSUInteger)priceLevel restaurants:(NSArray *)restaurants;

+ (instancetype)restaurantsInRadius:(NSUInteger)radius restaurants:(NSArray *)restaurants;

@end