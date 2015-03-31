//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationService.h"
#import "RestaurantSearchService.h"
#import "IRestaurantRepository.h"

@protocol ISchedulerFactory;


@interface RestaurantRepository : NSObject<IRestaurantRepository>
- (instancetype)initWithSearchService:(id <RestaurantSearchService>)searchService locationService:(LocationService *)locationService schedulerFactory:(id<ISchedulerFactory>) schedulerFactory;

- (BOOL)doRestaurantsHaveDifferentPriceLevels;

- (void)simulateNoRestaurantFound:(BOOL)simulateNotRestaurantFound;

- (void)simulateNetworkError:(BOOL)simulationEnabled;

- (void)simulateSlowResponse:(BOOL)enabled;

- (double)getMaxDistanceOfPlaces:(CLLocation *)currLocation;
@end