//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SearchParameter.h"


@implementation SearchParameter {

}
+ (instancetype)createWithCuisine:(NSString *)cuisine priceRange:(PriceLevelRange *)priceRange {
    return [[SearchParameter alloc] initWithCuisine:cuisine priceRange:priceRange];
}

- (id)initWithCuisine:(NSString *)cuisine priceRange:(PriceLevelRange *)priceRange {
    self = [super init];
    if (self != nil) {
        _cuisine = cuisine;
        _priceRange = priceRange;
    }
    return self;
}

@end