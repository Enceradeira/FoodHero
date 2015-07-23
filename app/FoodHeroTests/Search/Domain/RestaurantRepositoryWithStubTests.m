//
//  RestaurantRepositoryTests.m
//  FoodHero
//
//  Created by Jorg on 18/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRepository.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "CLLocationManagerProxyStub.h"
#import "RestaurantSearchServiceStub.h"
#import "RestaurantBuilder.h"
#import "RestaurantsInRadiusAndPriceRange.h"
#import "RestaurantRepositoryTests.h"
#import "PriceRange.h"
#import "GoogleDefinitions.h"
#import "FoodHero-Swift.h"
#import "FoodHeroTests-Swift.h"

@interface RestaurantRepositoryWithStubTests : RestaurantRepositoryTests

@end

@implementation RestaurantRepositoryWithStubTests {
    RestaurantRepository *_repository;
    RestaurantSearchServiceStub *_searchService;
    PlacesAPIStub *_placesAPI;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    id <ApplicationAssembly> assembly = [TyphoonComponents getAssembly];
    _placesAPI =  [assembly placesAPI];
    _searchService = [assembly restaurantSearchService];
    _repository = [assembly restaurantRepository];
}

- (RestaurantRepository *)repository {
    return _repository;
}

- (NSMutableArray *)restaurants:(NSInteger)nrRestaurants {
    NSMutableArray *restaurants = [NSMutableArray new];
    for (NSInteger i = 0; i < nrRestaurants; i++) {
        [restaurants addObject:[[RestaurantBuilder alloc] build]];
    }
    return restaurants;
}

- (void)test_getPlacesByCuisine_ShouldReturnAllPlacesFoundForGivenCuisine {
    Restaurant *restaurant = [[RestaurantBuilder alloc] build];
    [_placesAPI injectFindResults:@[restaurant]];

    CuisineAndOccasion *cuisine = [[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:nil];
    NSArray *places = [self.repository getPlacesBy:cuisine];
    assertThat(places, hasCountOf(1));
    assertThat(((Place *) places[0]).placeId, is(equalTo(restaurant.placeId)));
}

- (void)test_getPlacesByCuisine_ShouldCacheResults {
    [_placesAPI injectFindResults:@[[[RestaurantBuilder alloc] build]]];

    CuisineAndOccasion *cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:nil];
    Place *place1 = [self.repository getPlacesBy:cuisineAndOccasion][0];
    Place *place2 = [self.repository getPlacesBy:cuisineAndOccasion][0];

    assertThat(place1, is(equalTo(place2)));
}

- (void)test_getRestaurantForPlace_ShouldReturnRestaurantForPlace {
    Restaurant *restaurant = [[RestaurantBuilder alloc] build];
    [_placesAPI injectFindResults:@[restaurant]];

    CuisineAndOccasion *cuisine = [[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:nil];
    Place *place = [self.repository getPlacesBy:cuisine][0];

    ResolvedSearchLocation* currLocation = [[ResolvedSearchLocation alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275] description:@"Norwich"];
    Restaurant *restaurantFromPlace = [_repository getRestaurantFromPlace:place searchLocation:currLocation];
    assertThat(restaurantFromPlace, is(equalTo(restaurant)));
}

- (void)test_doRestaurantsHaveDifferentPriceLevels_ShouldReturnNo_WhenRestaurantsAreNotInCache {
    Restaurant *restaurant1 = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    Restaurant *restaurant2 = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    [_placesAPI injectFindResults:@[restaurant1, restaurant2]];

    assertThatBool([_repository doRestaurantsHaveDifferentPriceLevels], is(@(NO)));
}

- (void)test_doRestaurantsHaveDifferentPriceLevels_ShouldReturnYes_WhenRestaurantsHaveDifferentPriceLevels {
    Restaurant *restaurant1 = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    Restaurant *restaurant2 = [[[RestaurantBuilder alloc] withPriceLevel:1] build];
    [_placesAPI injectFindResults:@[restaurant1, restaurant2]];

    [_repository getPlacesBy:[[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:nil]]; // loads into cache

    assertThatBool([_repository doRestaurantsHaveDifferentPriceLevels], is(@(YES)));
}

- (void)test_doRestaurantsHaveDifferentPriceLevels_ShouldReturnNo_WhenRestaurantsHaveNotDifferentPriceLevels {
    Restaurant *restaurant1 = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    Restaurant *restaurant2 = [[[RestaurantBuilder alloc] withPriceLevel:0] build];
    [_placesAPI injectFindResults:@[restaurant1, restaurant2]];

    [_repository getPlacesBy:[[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:nil]]; // loads into cache

    assertThatBool([_repository doRestaurantsHaveDifferentPriceLevels], is(@(NO)));
}

- (void)test_getMaxDistanceOfPlaces_ShouldReturnDistanceToMostDistantPlace {
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:45 longitude:0];
    CLLocation *farawayLocation = [[CLLocation alloc] initWithLatitude:60 longitude:-45];
    CLLocation *closerLocation = [[CLLocation alloc] initWithLatitude:45 longitude:1];


    Restaurant *restaurant1 = [[[RestaurantBuilder alloc] withLocation:farawayLocation] build];
    Restaurant *restaurant2 = [[[RestaurantBuilder alloc] withLocation:closerLocation] build];
    [_placesAPI injectFindResults:@[restaurant1, restaurant2]];

    [_repository getPlacesBy:[[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:nil]]; // loads into cache
    double maxDistance = [_repository getMaxDistanceOfPlaces:userLocation];

    CLLocationDistance expectedMaxDistance = [userLocation distanceFromLocation:farawayLocation];
    assertThatDouble(maxDistance, is(equalToDouble(expectedMaxDistance)));
}

- (void)test_getMaxDistanceOfPlaces_ShouldReturn0_WhenNoPlacesInCache {
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:45 longitude:0];

    double maxDistance = [_repository getMaxDistanceOfPlaces:userLocation];

    assertThatDouble(maxDistance, is(equalToDouble(0)));
}

- (void)test_getMaxDistanceOfPlaces_ShouldReturn0_WhenNoPlacesFound {
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:45 longitude:0];

    [_placesAPI injectFindResults:@[]];
    [_repository getPlacesBy:[[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:nil]]; // loads 0 places into cache
    double maxDistance = [_repository getMaxDistanceOfPlaces:userLocation];

    assertThatDouble(maxDistance, is(equalToDouble(0)));
}


@end
