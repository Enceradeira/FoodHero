//
// Created by Jorg on 19/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "Restaurant.h"
#import "Place.h"
#import "CuisineAndOccasion.h"

@protocol IRestaurantRepository <NSObject>
- (NSArray *)getPlacesBy:(CuisineAndOccasion *)cuisine;

- (Restaurant *)getRestaurantFromPlace:(Place *)place;

- (double)getMaxDistanceOfPlaces:(CLLocation *)currLocation;

- (BOOL)doRestaurantsHaveDifferentPriceLevels;

- (void)simulateNoRestaurantFound:(BOOL)simulateNotRestaurantFound;

- (void)simulateNetworkError:(BOOL)simulationEnabled;

- (void)simulateSlowResponse:(BOOL)enabled;

@end