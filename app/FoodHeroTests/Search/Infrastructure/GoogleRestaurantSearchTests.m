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

@interface GoogleRestaurantSearchTests : XCTestCase

@end

@implementation GoogleRestaurantSearchTests {
    GoogleRestaurantSearch *_service;
    CLLocationCoordinate2D _norwich;
}

- (void)setUp
{
    [super setUp];
    _norwich.latitude =    52.6259;
    _norwich.longitude = 1.299484;

    _service = [GoogleRestaurantSearch new];
}

- (void)test_find_ShouldReturnResultsFromGoogle
{
    RestaurantSearchParams *parameter = [RestaurantSearchParams new];
    parameter.location = _norwich;

    NSArray *result = [_service find:parameter];

    assertThat(result, is(notNilValue()));
    assertThatUnsignedInt(result.count, is(greaterThan(@0U)));
    Restaurant *first = result[0];
    assertThatUnsignedInt(first.name.length,is(greaterThan(@0U)));
    assertThatUnsignedInt(first.vicinity.length,is(greaterThan(@0U)));
}

-(void)test_find_ShouldOnlyReturnRestaurants
{

}

@end
