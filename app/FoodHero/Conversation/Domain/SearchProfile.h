//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PriceRange.h"
#import "Place.h"
#import "DistanceRange.h"
#import "Restaurant.h"

@interface SearchProfile : NSObject
@property(nonatomic, readonly) NSString *cuisine;
@property(nonatomic, readonly) PriceRange *priceRange;
@property(nonatomic, readonly) DistanceRange *distanceRange;

+ (instancetype)createWithCuisine:(NSString *)cuisine priceRange:(PriceRange *)priceRange maxDistance:(DistanceRange *)distance;

- (id)initWithCuisine:(NSString *)cuisine priceRange:(PriceRange *)priceRange maxDistance:(DistanceRange *)distance;

- (double)scorePlace:(Place *)place distance:(double)distance restaurant:(Restaurant *)restaurant;
@end