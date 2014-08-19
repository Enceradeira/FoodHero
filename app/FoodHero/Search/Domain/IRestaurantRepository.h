//
// Created by Jorg on 19/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class Restaurant;
@class Place;

@protocol IRestaurantRepository <NSObject>
- (RACSignal *)getPlacesByCuisineOrderedByDistance:(NSString *)cuisine;

- (Restaurant *)getRestaurantFromPlace:(Place *)place;
@end