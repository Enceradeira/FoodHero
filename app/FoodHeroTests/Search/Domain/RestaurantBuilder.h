//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface RestaurantBuilder : NSObject
- (Restaurant *)build;

- (RestaurantBuilder *)withName:(NSString *)name;

- (RestaurantBuilder *)withVicinity:(NSString *)vicinity;

- (RestaurantBuilder *)withLocation:(CLLocation *)location;
@end