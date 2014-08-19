//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@class RestaurantRepository;


@interface RestaurantRepositoryTests : XCTestCase
- (NSArray *)getPlacesByCuisineOrderedByDistance:(NSString *)cuisine;

- (RestaurantRepository *)repository;
@end