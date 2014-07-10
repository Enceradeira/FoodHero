//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "RestaurantSearchService.h"
#import "LocationService.h"

@interface RestaurantSearch : NSObject
- (id)initWithSearchService:(id <RestaurantSearchService>)searchService withLocationService:(id <LocationService>)locationService;

- (RACSignal *)findBest;
@end