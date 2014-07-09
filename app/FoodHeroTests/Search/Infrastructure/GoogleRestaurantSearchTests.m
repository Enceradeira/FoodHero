//
//  GoogleRestaurantSearchTests.m
//  FoodHero
//
//  Created by Jorg on 08/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "GoogleRestaurantSearch.h"
#import <NSArray+LinqExtensions.h>

@interface GoogleRestaurantSearchTests : XCTestCase

@end

@implementation GoogleRestaurantSearchTests {
    GoogleRestaurantSearch *_service;
    RestaurantSearchParams *_parameter;
}

- (void)setUp
{
    [super setUp];
    CLLocationCoordinate2D norwich;
    norwich.latitude =    52.631944; // Maids Head Hotel, Tombland, Norwich
    norwich.longitude = 1.298889;

    _parameter = [RestaurantSearchParams new];
    _parameter.location = norwich;
    _parameter.radius = 10000;
    
    _service = [GoogleRestaurantSearch new];
}

- (NSArray *)find{
    NSArray *result = [_service find:_parameter];return result;
}

- (void)test_find_ShouldReturnResultsFromGoogle
{
    NSArray *result = [self find];

    assertThat(result, is(notNilValue()));
    assertThatUnsignedInt(result.count, is(greaterThan(@0U)));
    Restaurant *first = result[0];
    assertThatUnsignedInt(first.name.length,is(greaterThan(@0U)));
    assertThatUnsignedInt(first.vicinity.length,is(greaterThan(@0U)));
}

-(void)test_find_ShouldOnlyReturnRestaurants
{
    NSArray *result = [self find];
    NSArray *allTypes = [result linq_selectMany:^(Restaurant *r){return r.types;}];
    NSArray *types = [allTypes linq_distinct];

    assertThat(types, isNot(hasItem(@"church")));
    assertThat(types, hasItem(@"restaurant"));
}

@end
