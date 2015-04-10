//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantSearchParams.h"
#import "FoodHero-Swift.h"

@implementation RestaurantSearchParams {
}
- (instancetype)init {
    ;
    self = [super init];
    if (self != nil) {
        _types = @[[GoogleRestaurantTypes restaurant], [GoogleRestaurantTypes cafe]];
    }
    return self;
}

@end