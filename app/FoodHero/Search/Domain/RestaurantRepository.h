//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationService.h"
#import "RestaurantSearchService.h"

@class LocationService;


@interface RestaurantRepository : NSObject
- (instancetype)initWithSearchService:(id <RestaurantSearchService>)searchService locationService:(LocationService *)locationService;

- (RACSignal *)getPlacesByCuisine:(NSString *)cuisine;

- (Restaurant *)getRestaurantFromPlace:(Place *)place;
@end