//
//  GoogleRestaurantSearchTests.m
//  FoodHero
//
//  Created by Jorg on 08/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "GoogleRestaurantSearch.h"
#import "RestaurantRepository.h"
#import "CLLocationManagerProxyStub.h"

@interface GoogleRestaurantSearchTests : XCTestCase

@end

@implementation GoogleRestaurantSearchTests {
    GoogleRestaurantSearch *_service;
    RestaurantSearchParams *_parameter;
    NSString *_placeIdLibraryGrillNorwich;
    NSString *_placeIdMaidsHeadNorwich;
    CLLocation *_norwich;
    CLLocation *_london;
    NSString *_placeIdVeeraswamyLondon;
}

- (void)setUp {
    [super setUp];

    _placeIdLibraryGrillNorwich = @"ChIJZzNZ0-Dj2UcRn1Eq2l80nbw";
    _placeIdMaidsHeadNorwich = @"ChIJicLqAOjj2UcR1qA1_M1zFRI";
    _placeIdVeeraswamyLondon = @"ChIJnVRkK9QEdkgRz8uiqq2HfjM";


    // Maids Head Hotel, Tombland, Norwich
    _norwich = [[CLLocation alloc] initWithLatitude:52.631944 longitude:1.298889];
    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];

    _parameter = [RestaurantSearchParams new];
    _parameter.coordinate = _norwich.coordinate;
    _parameter.radius = 10000;

    _service = [GoogleRestaurantSearch new];
}

- (NSUInteger)findPlaceById:(NSString *)idLibraryGrillNorwich result:(NSArray *)result {
    return [result indexOfObjectPassingTest:^BOOL(id r, NSUInteger idx, BOOL *stop) {
        GooglePlace *place = r;
        BOOL found = [place.placeId isEqualToString:idLibraryGrillNorwich];
        stop = &found;
        return found;
    }];
}

- (void)test_findPlaces_ShouldReturnPlacesWithMatchingCuisineFirst {
    _parameter.cuisine = @"Steak house";

    NSArray *places = [_service findPlaces:_parameter];
    NSUInteger indexOfLibraryGrill = [self findPlaceById:_placeIdLibraryGrillNorwich result:places];
    NSUInteger indexOfMaidsHead = [self findPlaceById:_placeIdMaidsHeadNorwich result:places];

    assertThatInt(indexOfLibraryGrill, is(lessThan(@(indexOfMaidsHead))));
}

- (void)test_findPlaces_ShouldReturnPlacesWithinSpecifiedRadius {
    int specifiedRadius = 200;

    _parameter.cuisine = @"Indian";
    _parameter.radius = specifiedRadius;
    _parameter.coordinate = _norwich.coordinate;

    NSArray *places = [_service findPlaces:_parameter];
    assertThatUnsignedInt(places.count, is(greaterThan(@(1))));
    for (GooglePlace *place in places) {
        CLLocationDistance distance = [_norwich distanceFromLocation:place.location];
        assertThatDouble(distance, is(lessThanOrEqualTo(@(specifiedRadius * 3))));
    }
}

- (void)test_findPlaces_ShouldReturnPlacesWithinSpecifiedPriceRange {
    _parameter.cuisine = @"Indian";
    _parameter.radius = 5000;
    _parameter.coordinate = _london.coordinate;  // only london supports price range at the moment
    _parameter.minPriceLevel = 4;
    _parameter.maxPriceLevel = 4;

    NSArray *places = [[_service findPlaces:_parameter] linq_take:5];  // test on 5 places, not all 200
    assertThatUnsignedInt(places.count, is(greaterThan(@(1))));
    for (GooglePlace *place in places) {
        Restaurant *restaurant = [_service getRestaurantForPlace:place];
        assertThatUnsignedInt(restaurant.priceLevel, is(equalTo(@4)));
    }
}

- (void)test_getRestaurantForPlace_ShouldReturnRestaurantAtPlace {
    GooglePlace *place = [GooglePlace createWithPlaceId:_placeIdVeeraswamyLondon location:[CLLocation new]];

    Restaurant *restaurant = [_service getRestaurantForPlace:place];

    assertThatUnsignedInt(restaurant.name.length, is(greaterThan(@0U)));
    assertThatUnsignedInt(restaurant.vicinity.length, is(greaterThan(@0U)));
    assertThat(restaurant.placeId, is(equalTo(place.placeId)));
    assertThat(restaurant.location, is(notNilValue()));
    assertThatUnsignedInt(restaurant.priceLevel, is(greaterThan(@(0))));
}



- (void)test_studyPrice {
    return;
    CLLocationDistance radius = 50000;

    _parameter.cuisine = @"Indian";
    _parameter.radius = radius;
    // _parameter.coordinate = [[CLLocation alloc] initWithLatitude:40.7127 longitude:-74.0059].coordinate; // NY
    _parameter.coordinate = _london.coordinate; // London
    // _parameter.coordinate = _norwich.coordinate;
    _parameter.minPriceLevel = 3;
    _parameter.maxPriceLevel = 4;

    for (GooglePlace *place in [_service findPlaces:_parameter]) {
        CLLocationDistance distance = [[place location] distanceFromLocation:_london];

        Restaurant *r = [_service getRestaurantForPlace:place];
        NSLog([NSString stringWithFormat:@"Level %u m: %f ¦ %@ ¦ %@", r.priceLevel, distance, r.name, r.vicinity]);
    }

}


@end
