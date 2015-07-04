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
@property(nonatomic, readonly) NSString *occasion;
@property(nonatomic, readonly) CLLocation *searchLocation;

+ (instancetype)createWithCuisine:(NSString *)cuisine
                       priceRange:(PriceRange *)priceRange
                      maxDistance:(DistanceRange *)distance
                         occasion:(NSString *)occasion
                         location:(CLLocation *)location;

- (id)initWithCuisine:(NSString *)cuisine
           priceRange:(PriceRange *)priceRange
          maxDistance:(DistanceRange *)distance
             occasion:(NSString *)occasion
             location:(CLLocation *)location;

- (double)scorePlace:(Place *)place normalizedDistance:(double)distance restaurant:(Restaurant *)restaurant;
@end