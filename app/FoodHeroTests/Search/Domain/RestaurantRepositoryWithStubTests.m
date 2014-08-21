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
#import "GoogleRestaurantSearch.h"
#import "RestaurantsInRadiusAndPriceRange.h"
#import "RestaurantRepositoryTests.h"
#import "PriceRange.h"

@interface RestaurantRepositoryWithStubTests : RestaurantRepositoryTests

@end

@implementation RestaurantRepositoryWithStubTests {
    RestaurantRepository *_repository;
    RestaurantSearchServiceStub *_searchService;
    CLLocationManagerProxyStub *_locationManager;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _searchService = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _locationManager = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationManagerProxy];
    _repository = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantRepository];
}

- (RestaurantRepository *)repository {
    return _repository;
}

- (NSMutableArray *)restaurants:(int)nrRestaurants {
    NSMutableArray *restaurants = [NSMutableArray new];
    for (int i = 0; i < nrRestaurants; i++) {
        [restaurants addObject:[[RestaurantBuilder alloc] build]];
    }
    return restaurants;
}


- (void)test_getPlacesByCuisine_ShouldReturnAllPlacesFoundForGivenCuisine {
    Restaurant *restaurant = [[RestaurantBuilder alloc] build];
    [_searchService injectFindResults:@[restaurant]];

    NSArray *places = [self getPlacesByCuisine:@"Asian"];
    assertThat(places, hasCountOf(1));
    assertThat(((Place *) places[0]).placeId, is(equalTo(restaurant.placeId)));
}

- (void)test_getPlacesByCuisine_ShouldCacheResults {
    [_searchService injectFindResults:@[[[RestaurantBuilder alloc] build]]];

    Place *place1 = [self getPlacesByCuisine:@"Asian"][0];
    Place *place2 = [self getPlacesByCuisine:@"Asian"][0];

    assertThat(place1, is(equalTo(place2)));
}

- (void)test_getPlacesByCuisine_ShouldFlushCache_WhenCuisineChanges {
    [_searchService injectFindResults:@[[[RestaurantBuilder alloc] build]]];

    Place *place1 = [self getPlacesByCuisine:@"Asian"][0];
    Place *place2 = [self getPlacesByCuisine:@"Swiss"][0];

    assertThat(place1, isNot(equalTo(place2)));
}

- (void)test_getPlacesByCuisine_ShouldFlushCache_WhenLocationChanges {
    [_searchService injectFindResults:@[[[RestaurantBuilder alloc] build]]];

    [_locationManager injectLatitude:15.098 longitude:-50.56];
    Place *place1 = [self getPlacesByCuisine:@"Asian"][0];

    [_locationManager injectLatitude:30 longitude:-20];
    Place *place2 = [self getPlacesByCuisine:@"Asian"][0];

    assertThat(place1, isNot(equalTo(place2)));
}

- (void)test_getPlacesByCuisine_ShouldNotFlushCache_WhenLocationDoesNotChangeALot {
    [_searchService injectFindResults:@[[[RestaurantBuilder alloc] build]]];
    [_locationManager injectLatitude:52.631249 longitude:1.299053];
    Place *place1 = [self getPlacesByCuisine:@"Asian"][0];

    [_locationManager injectLatitude:52.630813 longitude:1.299279];
    Place *place2 = [self getPlacesByCuisine:@"Asian"][0];

    assertThat(place1, is(equalTo(place2)));
}

- (void)test_getPlacesByCuisine_ShouldDecreaseSearchRadius_WhenTwoManyRestaurantsFound {
    NSMutableArray *listWithMaxNrRestaurants = [self restaurants:GOOGLE_MAX_SEARCH_RESULTS];
    NSMutableArray *listWithLessRestaurants = [self restaurants:GOOGLE_MAX_SEARCH_RESULTS - 1];

    [_searchService injectFindResultsWithRadiusAndPriceRange:@[
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:500 restaurants:@[]],
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:GOOGLE_MAX_SEARCH_RADIUS / 3 restaurants:listWithLessRestaurants],
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:GOOGLE_MAX_SEARCH_RADIUS restaurants:listWithMaxNrRestaurants]]];


    NSArray *places = [self getPlacesByCuisine:@"Asian"];
    assertThat(places, hasCountOf(listWithLessRestaurants.count));
}

- (void)test_getPlacesByCuisine_ShouldInitializePlaceWithPriceLevel {
    NSUInteger cheap = GOOGLE_PRICE_LEVEL_MIN;
    NSUInteger medium = GOOGLE_PRICE_LEVEL_MAX / 2;
    NSUInteger expensive = GOOGLE_PRICE_LEVEL_MAX;
    Restaurant *cheapRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:cheap] build];
    Restaurant *mediumPricedRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:medium] build];
    Restaurant *expensiveRestaurant = [[[RestaurantBuilder alloc] withPriceLevel:expensive] build];

    [_searchService injectFindResultsWithRadiusAndPriceRange:@[
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:GOOGLE_MAX_SEARCH_RADIUS priceLevel:cheap restaurants:@[cheapRestaurant]],
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:GOOGLE_MAX_SEARCH_RADIUS priceLevel:medium restaurants:@[mediumPricedRestaurant]],
            [RestaurantsInRadiusAndPriceRange restaurantsInRadius:GOOGLE_MAX_SEARCH_RADIUS priceLevel:expensive restaurants:@[expensiveRestaurant]]]];

    NSArray *places = [self getPlacesByCuisine:@"Asian"];
    assertThat(places, hasCountOf(3));
    NSArray *priceLevels = [places linq_select:^(Place *p) {
        return @(p.priceLevel);
    }];
    assertThat(priceLevels, hasItem(@(cheap)));
    assertThat(priceLevels, hasItem(@(medium)));
    assertThat(priceLevels, hasItem(@(expensive)));
}

- (void)test_getPlacesByCuisine_ShouldCompleteAfterAllPlacesHaveBeenReturned {
    __block Place *place;
    __block BOOL isCompleted;

    [_searchService injectFindResults:@[[[RestaurantBuilder alloc] build]]];

    RACSignal *result = [_repository getPlacesByCuisine:@"Asian"];
    [result subscribeNext:^(Place *p) {
        place = p;
    }];
    [result subscribeCompleted:^() {
        isCompleted = YES;
    }];

    assertThat(place, is(notNilValue()));
    assertThatBool(isCompleted, is(equalToBool(YES)));
}

- (void)test_getRestaurantForPlace_ShouldReturnRestaurantForPlace {
    Restaurant *restaurant = [[RestaurantBuilder alloc] build];
    [_searchService injectFindResults:@[restaurant]];

    Place *place = [self getPlacesByCuisine:@"Mongolian"][0];

    Restaurant *restaurantFromPlace = [_repository getRestaurantFromPlace:place];
    assertThat(restaurantFromPlace, is(equalTo(restaurant)));
}

@end
