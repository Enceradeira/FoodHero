//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SearchParameter.h"
#import "DesignByContractException.h"


@implementation SearchParameter {

}
+ (instancetype)createWithCuisine:(NSString *)cuisine priceRange:(PriceLevelRange *)priceRange maxDistance:(double)maxDistance {
    return [[SearchParameter alloc] initWithCuisine:cuisine priceRange:priceRange maxDistance:maxDistance];
}

- (id)initWithCuisine:(NSString *)cuisine priceRange:(PriceLevelRange *)priceRange maxDistance:(double)maxDistance {
    self = [super init];
    if (self != nil) {
        if (maxDistance < 0) {
            @throw [DesignByContractException createWithReason:@"maxDistance can't be less than 0"];
        }
        _cuisine = cuisine;
        _priceRange = priceRange;
        _maxDistance = maxDistance;
    }
    return self;
}

@end