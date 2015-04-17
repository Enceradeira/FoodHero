//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@class RestaurantRepository;
@class CuisineAndOccasion;


@interface RestaurantRepositoryTests : XCTestCase
- (NSArray *)getPlacesBy:(CuisineAndOccasion *)cuisine;

- (RestaurantRepository *)repository;
@end