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

@implementation CuisineAndOccasionTests

- (void)test_isEqual_ShouldBeTrue_WhenEqualValues {
    CuisineAndOccasion *value1 = [[CuisineAndOccasion alloc] initWithOccasion:@"lunch" cuisine:@"indian"];
    CuisineAndOccasion *value2 = [[CuisineAndOccasion alloc] initWithOccasion:@"lunch" cuisine:@"indian"];

    XCTAssertEqualObjects(value1, value2);
}

- (void)test_isEqual_ShouldBeTrue_WhenEqualValuesWithNil {
    CuisineAndOccasion *value1 = [[CuisineAndOccasion alloc] initWithOccasion:@"lunch" cuisine:nil];
    CuisineAndOccasion *value2 = [[CuisineAndOccasion alloc] initWithOccasion:@"lunch" cuisine:nil];

    XCTAssertEqualObjects(value1, value2);
}


- (void)test_isEqual_ShouldBeFalse_WhenDifferentValues {
    CuisineAndOccasion *value1 = [[CuisineAndOccasion alloc] initWithOccasion:@"lunch" cuisine:@"indian"];
    CuisineAndOccasion *value2 = [[CuisineAndOccasion alloc] initWithOccasion:@"breakfast" cuisine:@"indian"];

    XCTAssertNotEqualObjects(value1, value2);
}

@end
