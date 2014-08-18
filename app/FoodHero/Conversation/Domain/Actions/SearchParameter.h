//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PriceLevelRange.h"

@interface SearchParameter : NSObject
@property(nonatomic, readonly) NSString *cuisine;
@property(nonatomic, readonly) PriceLevelRange *priceRange;

+ (instancetype)createWithCuisine:(NSString *)cuisine priceRange:(PriceLevelRange *)priceRange;

- (id)initWithCuisine:(NSString *)cuisine priceRange:(PriceLevelRange *)priceRange;
@end