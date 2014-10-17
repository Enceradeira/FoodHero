//
// Created by Jorg on 04/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Restaurant;

@protocol RestaurantController <NSObject>
- (void)setRestaurant:(Restaurant *)restaurant;
@end