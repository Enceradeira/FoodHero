//
//  CuisineAndOccasionTests.m
//  FoodHero
//
//  Created by Jorg on 17/04/15.
//  Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CuisineAndOccasion.h"

@interface CuisineAndOccasionTests : XCTestCase

@end

@implementation CuisineAndOccasionTests {
    CLLocation *_norwich;
    CLLocation *_london;
}

- (void)setUp {
    [super setUp];

    _norwich = [[CLLocation alloc] initWithLatitude:52.631944 longitude:1.298889];
    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];
}

- (void)test_isEqual_ShouldBeTrue_WhenEqualValues {
    CLLocation *norwichClone = [[CLLocation alloc] initWithLatitude:_norwich.coordinate.latitude longitude:_norwich.coordinate.longitude];

    CuisineAndOccasion *value1 = [[CuisineAndOccasion alloc] initWithOccasion:@"lunch" cuisine:@"indian" location:_norwich];
    CuisineAndOccasion *value2 = [[CuisineAndOccasion alloc] initWithOccasion:@"lunch" cuisine:@"indian" location:norwichClone];

    XCTAssertEqualObjects(value1, value2);
}

- (void)test_isEqual_ShouldBeTrue_WhenEqualValuesWithNil {
    CuisineAndOccasion *value1 = [[CuisineAndOccasion alloc] initWithOccasion:@"lunch" cuisine:nil location:nil];
    CuisineAndOccasion *value2 = [[CuisineAndOccasion alloc] initWithOccasion:@"lunch" cuisine:nil location:nil];

    XCTAssertEqualObjects(value1, value2);
}


- (void)test_isEqual_ShouldBeFalse_WhenDifferentValues {
    CuisineAndOccasion *value1 = [[CuisineAndOccasion alloc] initWithOccasion:@"lunch" cuisine:@"indian" location:_norwich];
    CuisineAndOccasion *value2 = [[CuisineAndOccasion alloc] initWithOccasion:@"breakfast" cuisine:@"indian" location:_norwich];

    XCTAssertNotEqualObjects(value1, value2);

    value1 = [[CuisineAndOccasion alloc] initWithOccasion:@"lunch" cuisine:@"indian" location:_norwich];
    value2 = [[CuisineAndOccasion alloc] initWithOccasion:@"lunch" cuisine:@"indian" location:_london];

    XCTAssertNotEqualObjects(value1, value2);
}

@end
