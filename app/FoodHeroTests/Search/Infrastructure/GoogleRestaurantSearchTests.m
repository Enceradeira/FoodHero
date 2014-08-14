//
//  GoogleRestaurantSearchTests.m
//  FoodHero
//
//  Created by Jorg on 08/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "GoogleRestaurantSearch.h"

@interface GoogleRestaurantSearchTests : XCTestCase

@end

@implementation GoogleRestaurantSearchTests {
    GoogleRestaurantSearch *_service;
    RestaurantSearchParams *_parameter;
    NSString *_placeIdLibraryGrill;
    NSString *_placeIdMaidsHead;
    CLLocation *_norwich;
}

- (void)setUp {
    [super setUp];

    _placeIdLibraryGrill = @"ChIJZzNZ0-Dj2UcRn1Eq2l80nbw";
    _placeIdMaidsHead = @"ChIJicLqAOjj2UcR1qA1_M1zFRI";


    // Maids Head Hotel, Tombland, Norwich
    _norwich = [[CLLocation alloc] initWithLatitude:52.631944 longitude:1.298889];

    _parameter = [RestaurantSearchParams new];
    _parameter.coordinate = _norwich.coordinate;
    _parameter.radius = 10000;

    _service = [GoogleRestaurantSearch new];
}

- (NSUInteger)findPlaceById:(NSString *)idLibraryGrillNorwich result:(NSArray *)result {
    return [result indexOfObjectPassingTest:^BOOL(id r, NSUInteger idx, BOOL *stop) {
        Place *place = r;
        BOOL found = [place.placeId isEqualToString:idLibraryGrillNorwich];
        stop = &found;
        return found;
    }];
}

- (void)test_findPlaces_ShouldReturnPlacesWithMatchingCuisineFirst {
    _parameter.cuisine = @"Steak house";

    NSArray *places = [_service findPlaces:_parameter];
    NSUInteger indexOfLibraryGrill = [self findPlaceById:_placeIdLibraryGrill result:places];
    NSUInteger indexOfMaidsHead = [self findPlaceById:_placeIdMaidsHead result:places];

    assertThatInt(indexOfLibraryGrill, is(lessThan(@(indexOfMaidsHead))));
}

- (void)test_findPlaces_ShouldReturnPlacesWithinSpecifiedRadius {
    int specifiedRadius = 200;

    _parameter.cuisine = @"Indian";
    _parameter.radius = specifiedRadius;
    _parameter.coordinate = _norwich.coordinate;

    NSArray *places = [_service findPlaces:_parameter];
    assertThatUnsignedInt(places.count, is(greaterThan(@(1))));
    for (Place *place in places) {
        CLLocationDistance distance = [_norwich distanceFromLocation:place.location];
        assertThatDouble(distance, is(lessThanOrEqualTo(@(specifiedRadius*3))));
    }
}

- (void)test_getRestaurantForPlace_ShouldReturnRestaurantAtPlace {
    Place *place = [Place createWithPlaceId:_placeIdLibraryGrill location:[CLLocation new]];

    Restaurant *restaurant = [_service getRestaurantForPlace:place];

    assertThatUnsignedInt(restaurant.name.length, is(greaterThan(@0U)));
    assertThatUnsignedInt(restaurant.vicinity.length, is(greaterThan(@0U)));
    assertThat(restaurant.placeId, is(equalTo(place.placeId)));
}

@end
