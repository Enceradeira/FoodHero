//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PriceLevelRange.h"

@interface SearchParameter : NSObject
@property(nonatomic, readonly) NSString *cuisine;
@property(nonatomic, readonly) PriceLevelRange *priceRange;
@property(nonatomic, readonly) double maxDistance;

+ (instancetype)createWithCuisine:(NSString *)cuisine priceRange:(PriceLevelRange *)priceRange maxDistance:(double)distance;

- (id)initWithCuisine:(NSString *)cuisine priceRange:(PriceLevelRange *)priceRange maxDistance:(double)distance;
@end