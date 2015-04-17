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
- (RACSignal *)getPlacesBy:(CuisineAndOccasion *)cuisine;

- (Restaurant *)getRestaurantFromPlace:(Place *)place;

- (double)getMaxDistanceOfPlaces:(CLLocation *)currLocation;
@end