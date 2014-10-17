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
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"
#import "SearchException.h"

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
    NSString *_placeIdEveningRiverCruiseYork;
}

- (void)setUp {
    [super setUp];

    _placeIdLibraryGrillNorwich = @"ChIJZzNZ0-Dj2UcRn1Eq2l80nbw";
    _placeIdMaidsHeadNorwich = @"ChIJicLqAOjj2UcR1qA1_M1zFRI";
    _placeIdVeeraswamyLondon = @"ChIJnVRkK9QEdkgRz8uiqq2HfjM";
    _placeIdEveningRiverCruiseYork = @"ChIJh_uMeqYxeUgR0_Wzw6fzne4";


    // Maids Head Hotel, Tombland, Norwich
    _norwich = [[CLLocation alloc] initWithLatitude:52.631944 longitude:1.298889];
    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];

    _parameter = [RestaurantSearchParams new];
    _parameter.coordinate = _norwich.coordinate;
    _parameter.radius = 10000;

    _service = [GoogleRestaurantSearch new];
}

- (GooglePlace *)findPlaceById:(NSString *)idLibraryGrillNorwich result:(NSArray *)result {
    return [[result linq_where:^(GooglePlace *place) {
        return [place.placeId isEqualToString:idLibraryGrillNorwich];
    }] linq_firstOrNil];
}

- (void)test_findPlaces_ShouldReturnPlacesWithMatchingCuisineFirst {
    _parameter.cuisine = @"Steak house";
    NSArray *places = [_service findPlaces:_parameter];

    // cuisineRelevance should become smaller when iterating through the results
    GooglePlace *firstPlace = (GooglePlace *) places[0];
    GooglePlace *lastPlace = (GooglePlace *) places[places.count - 1];
    assertThatDouble(firstPlace.cuisineRelevance, is(equalTo(@(1))));
    assertThatDouble(lastPlace.cuisineRelevance, is(lessThan(@(1))));

    for (NSUInteger i = 1; i < places.count; i++) {
        GooglePlace *prevPlace = places[i - 1];
        GooglePlace *nextPlace = places[i];
        assertThatDouble(prevPlace.cuisineRelevance, is(greaterThan(@(nextPlace.cuisineRelevance))));
    }

    // grill should be more relevant because we search for Steak house
    GooglePlace *libraryGrill = [self findPlaceById:_placeIdLibraryGrillNorwich result:places];
    GooglePlace *maidsHead = [self findPlaceById:_placeIdMaidsHeadNorwich result:places];
    assertThatDouble(libraryGrill.cuisineRelevance, is(greaterThan(@(maidsHead.cuisineRelevance))));
}

- (void)test_findPlaces_ShouldReturnCuisineRelevance0ForMostIrrelevantPlace_WhenSearchRadiusEqualMaxSearchRadius {
    _parameter.radius = GOOGLE_MAX_SEARCH_RADIUS;
    GooglePlace *mostIrrelevantPlace = [[_service findPlaces:_parameter] linq_lastOrNil];

    assertThatDouble(mostIrrelevantPlace.cuisineRelevance, is(equalTo(@0)));
}

- (void)test_findPlaces_ShouldReturnCuisineRelevanceGreaterThan0ForMostIrrelevantPlace_WhenSearchRadiusLessThanMaxSearchRadius {
    _parameter.radius = GOOGLE_MAX_SEARCH_RADIUS / 2;
    _parameter.cuisine = @"French";
    GooglePlace *mostIrrelevantPlace = [[_service findPlaces:_parameter] linq_lastOrNil];

    assertThatDouble(mostIrrelevantPlace.cuisineRelevance, is(greaterThan(@0)));
}

- (void)test_findPlaces_ShouldReturnPlacesWithinSpecifiedRadius {
    NSInteger specifiedRadius = 200;

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

- (void)test_findPlaces_ShouldThrowException_WhenRadiusGreaterThanMaxSearchRadius {
    _parameter.radius = GOOGLE_MAX_SEARCH_RADIUS + 1;
    assertThat(^() {
        [_service findPlaces:_parameter];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_findPlaces_ShouldThrowException_WhenThereIsANetworkingError {
    _service.baseAddress = @"https://jennius.com"; // this should throw a networking error since no search is available at this address
    _service.timeout = 0.1;

    assertThat(^() {
        [_service findPlaces:_parameter];
    }, throwsExceptionOfType([SearchException class]));
}

- (void)test_getRestaurantForPlace_ShouldThrowException_WhenThereIsANetworkingError {
    _service.baseAddress = @"https://jennius.com"; // this should throw a networking error since no search is available at this address
    _service.timeout = 0.1;

    assertThat(^() {
        GooglePlace *place = [GooglePlace createWithPlaceId:_placeIdVeeraswamyLondon location:[CLLocation new] cuisineRelevance:34];
        [_service getRestaurantForPlace:place];
    }, throwsExceptionOfType([SearchException class]));
}

- (void)test_getRestaurantForPlace_ShouldReturnRestaurantAtPlace {
    GooglePlace *place = [GooglePlace createWithPlaceId:_placeIdVeeraswamyLondon location:[CLLocation new] cuisineRelevance:34];

    Restaurant *restaurant = [_service getRestaurantForPlace:place];

    assertThatUnsignedInt(restaurant.name.length, is(greaterThan(@0U)));
    assertThatUnsignedInt(restaurant.vicinity.length, is(greaterThan(@0U)));
    assertThat(restaurant.address, is(equalTo(@"Mezzanine Floor, Victoria House\n99-101 Regent St, London W1B 4RS")));
    assertThatUnsignedInt(restaurant.openingStatus.length, is(greaterThan(@0U)));
    assertThatUnsignedInt(restaurant.openingHours.length, is(greaterThan(@0U)));
    assertThat(restaurant.phoneNumber, is(equalTo(@"020 7734 1401")));
    assertThat(restaurant.url, is(equalTo(@"veeraswamy.com")));
    assertThat(restaurant.openingHours, containsString(@"am"));
    assertThat(restaurant.openingHours, containsString(@"pm"));
    assertThat(restaurant.placeId, is(equalTo(place.placeId)));
    assertThat(restaurant.location, is(notNilValue()));
    assertThatUnsignedInt(restaurant.priceLevel, is(greaterThan(@(0))));
    assertThatDouble(restaurant.cuisineRelevance, is(equalTo(@(34))));
}

-(void)test_getRestaurantForPlace_ShouldSetNoInfoAboutOpeningHours_WhenNoOpeningHoursAvailable{
    GooglePlace *place = [GooglePlace createWithPlaceId:_placeIdEveningRiverCruiseYork location:[CLLocation new] cuisineRelevance:34];

    Restaurant *restaurant = [_service getRestaurantForPlace:place];
    assertThat(restaurant.openingHours, is(equalTo(@"")));
    assertThat(restaurant.openingStatus, is(equalTo(@"")));
}

@end
