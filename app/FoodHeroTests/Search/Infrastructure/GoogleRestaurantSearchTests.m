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
}

- (void)setUp {
    [super setUp];

    _placeIdLibraryGrill = @"ChIJZzNZ0-Dj2UcRn1Eq2l80nbw";
    _placeIdMaidsHead = @"ChIJicLqAOjj2UcR1qA1_M1zFRI";

    CLLocationCoordinate2D norwich;
    norwich.latitude = 52.631944; // Maids Head Hotel, Tombland, Norwich
    norwich.longitude = 1.298889;

    _parameter = [RestaurantSearchParams new];
    _parameter.location = norwich;
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

- (void)test_findPlaces_ShouldReturnRestaurantsWithMatchingCuisineFirst {
    _parameter.cuisine = @"Steak house";

    NSArray *result1 = [_service findPlaces:_parameter];
    NSArray *restaurants = result1;
    NSUInteger indexOfLibraryGrill = [self findPlaceById:_placeIdLibraryGrill result:restaurants];
    NSUInteger indexOfMaidsHead = [self findPlaceById:_placeIdMaidsHead result:restaurants];

    assertThatInt(indexOfLibraryGrill, is(lessThan(@(indexOfMaidsHead))));
}

- (void)test_getRestaurantForPlace_ShouldReturnRestaurantAtPlace {
    Place *place = [Place createWithPlaceId:_placeIdLibraryGrill];

    Restaurant *restaurant = [_service getRestaurantForPlace:place];

    assertThatUnsignedInt(restaurant.name.length, is(greaterThan(@0U)));
    assertThatUnsignedInt(restaurant.vicinity.length, is(greaterThan(@0U)));
    assertThat(restaurant.placeId, is(equalTo(place.placeId)));
}

@end
