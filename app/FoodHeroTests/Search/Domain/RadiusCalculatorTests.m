//
//  RadiusCalculatorTests.m
//  FoodHero
//
//  Created by Jorg on 15/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RadiusCalculator.h"
#import "GoogleRestaurantSearch.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"
#import "RestaurantsInRadiusAndPriceRange.h"
#import "GoogleDefinitions.h"

@interface RadiusCalculatorTests : XCTestCase

@end

@implementation RadiusCalculatorTests

- (NSArray *)elements:(NSInteger)nrElements {
    NSMutableArray *elements = [NSMutableArray new];
    for (NSInteger i = 0; i < nrElements; i++) {
        [elements addObject:@"just an element"];
    }
    return elements;
}

- (NSArray *)doUnitlRightNrOfElementsReturned:(NSArray *)results {
    NSArray *result = [RadiusCalculator doUntilRightNrOfElementsReturned:^(double radius) {
        return [[[results linq_where:^BOOL(RestaurantsInRadiusAndPriceRange *r) {
            return r.radius >= radius;
        }] linq_select:^(RestaurantsInRadiusAndPriceRange *r) {
            return r.restaurants;
        }] linq_firstOrNil];
    }];
    return result;
}

- (void)test_doUntilRightNrOfElementsReturned_ShouldReturnElementsAtMaxRadius_WhenLessThanMaxResultsReturned {
    NSArray *elements = [self elements:GOOGLE_MAX_SEARCH_RESULTS - 1];

    NSArray *result = [RadiusCalculator doUntilRightNrOfElementsReturned:^(double radius) {
        return elements;
    }];

    assertThat(result, is(equalTo(elements)));
}

- (void)test_doUntilRightNrOfElementsReturned_ShouldThrowException_WhenNilResultIsAlwaysReturned {
    assertThat(^() {
        [RadiusCalculator doUntilRightNrOfElementsReturned:^(double radius) {
            return (NSArray *) nil;
        }];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_doUntilRightNrOfElementsReturned_ShouldReturnEmptyArray_WhenEmptyResultIsAlwaysReturned {
    NSArray *result = [RadiusCalculator doUntilRightNrOfElementsReturned:^(double radius) {
        return [NSArray new];
    }];

    assertThatUnsignedInt(result.count, is(equalTo(@0)));
}

- (void)test_doUntilRightNrOfElementsReturned_ShouldReturnFirstResultsWithLessThanMaxResult {
    NSArray *elementsAtRadius2000 = [self elements:GOOGLE_MAX_SEARCH_RESULTS - 1];

    NSArray *results = @[
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:100 restaurants:[self elements:GOOGLE_MAX_SEARCH_RESULTS - 40]],
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:500 restaurants:[self elements:GOOGLE_MAX_SEARCH_RESULTS - 20]],
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:2000 restaurants:elementsAtRadius2000],
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:10000 restaurants:[self elements:GOOGLE_MAX_SEARCH_RESULTS]],
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:GOOGLE_MAX_SEARCH_RADIUS restaurants:[self elements:GOOGLE_MAX_SEARCH_RESULTS + 1]],
    ];

    NSArray *result = [self doUnitlRightNrOfElementsReturned:results];

    assertThat(result, is(equalTo(elementsAtRadius2000)));
}

- (void)test_doUntilRightNrOfElementsReturned_ShouldReturnResultFromSmallestRadius_WhenAllOtherRadiusYieldTooManyResults {
    NSArray *elementsAtRadius2000 = [self elements:GOOGLE_MAX_SEARCH_RESULTS - 1];

    NSArray *results = @[
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:2000 restaurants:elementsAtRadius2000],
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:GOOGLE_MAX_SEARCH_RADIUS restaurants:[self elements:GOOGLE_MAX_SEARCH_RESULTS]],
    ];

    NSArray *result = [self doUnitlRightNrOfElementsReturned:results];

    assertThat(result, is(equalTo(elementsAtRadius2000)));
}


@end
