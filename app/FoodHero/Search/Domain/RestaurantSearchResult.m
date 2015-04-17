//
// Created by Jorg on 17/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import "RestaurantSearchResult.h"


@implementation RestaurantSearchResult {

}

- (instancetype)initWithRestaurant:(Restaurant *)restaurant searchParams:(SearchProfile *)searchParams {
    self = [super init];
    if (self != nil) {
        _restaurant = restaurant;
        _searchParams = searchParams;
    }
    return self;
}
@end