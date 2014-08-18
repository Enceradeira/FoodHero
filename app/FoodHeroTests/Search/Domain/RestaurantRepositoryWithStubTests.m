//
//  RestaurantRepositoryTests.m
//  FoodHero
//
//  Created by Jorg on 18/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "RestaurantRepository.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "CLLocationManagerProxyStub.h"
#import "RestaurantSearchServiceStub.h"
#import "RestaurantBuilder.h"
#import "GoogleRestaurantSearch.h"
#import "RestaurantsAtRadius.h"
#import "RestaurantRepositoryTests.h"

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

    [_searchService injectFindResultsWithRadius:@[
            [RestaurantsAtRadius create:500 restaurants:@[]],
            [RestaurantsAtRadius create:GOOGLE_MAX_SEARCH_RADIUS / 3 restaurants:listWithLessRestaurants],
            [RestaurantsAtRadius create:GOOGLE_MAX_SEARCH_RADIUS restaurants:listWithMaxNrRestaurants]]];


    NSArray *places = [self getPlacesByCuisine:@"Asian"];
    assertThat(places, hasCountOf(listWithLessRestaurants.count));
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

@end
