//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "RestaurantSearchService.h"

@interface RestaurantSearchServiceStub : NSObject <RestaurantSearchService>
- (void)injectFindResults:(NSArray *)restaurants;

- (void)injectFindNothing;

- (void)injectFindSomething;

- (void)injectFindResultsWithRadiusAndPriceRange:(NSArray *)restaurantsAtRadius;
@end