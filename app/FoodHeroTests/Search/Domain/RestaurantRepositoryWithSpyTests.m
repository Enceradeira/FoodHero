//
//  RestaurantRepositoryWithSpyTests.m
//  FoodHero
//
//  Created by Jorg on 18/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "RestaurantSearchServiceSpy.h"
#import "ApplicationAssembly.h"
#import "TyphoonComponents.h"
#import "RestaurantSearch.h"
#import "RestaurantRepository.h"
#import "RestaurantRepositoryTests.h"
#import "StubAssembly.h"
#import "RestaurantBuilder.h"
#import "FoodHeroTests-Swift.h"

@interface RestaurantRepositoryWithSpyTests : RestaurantRepositoryTests

@end

@implementation RestaurantRepositoryWithSpyTests {
    RestaurantSearchServiceSpy *_searchService;
    RestaurantRepository *_repository;
    CuisineAndOccasion *_cuisineAndOccasion;
    ResolvedSearchLocation *_location;
    PlacesAPISpy *_placesAPI;
}

- (void)setUp {
    [super setUp];
    [TyphoonComponents configure:[StubAssembly new]];

    _searchService = [RestaurantSearchServiceSpy new];
    _placesAPI = [PlacesAPISpy new];

    _repository = [[RestaurantRepository alloc] initWithSearchService:_searchService placesAPI:_placesAPI];
    _location = [[ResolvedSearchLocation alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:12.6259 longitude:1.33212] description:@"Norwich"];
    _cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:_location.location];
}

- (RestaurantRepository *)repository {
    return _repository;
}

- (void)test_getPlacesByCuisine_shouldSearchWithCorrectParameters {
    NSArray *result;
    result = [self.repository getPlacesBy:_cuisineAndOccasion];

    CLLocation *location = _cuisineAndOccasion.location;
    NSString *cuisine = _cuisineAndOccasion.cuisine;
    NSString *occasion = _cuisineAndOccasion.occasion;
    assertThatBool([_placesAPI findPlacesWasCalledWithCusine:cuisine occasion:occasion location:location], is(@(YES)));
}

- (void)test_getRestaurantFromPlace_ShouldReturnRestaurantFromCache_WhenCalledMoreThanOnce {
    NSArray *result;
    result = [self.repository getPlacesBy:_cuisineAndOccasion]; // this queries the location which is a precondition for getRestaurantFromPlace

    Restaurant *place = [[RestaurantBuilder alloc] build];
    assertThat([_repository getRestaurantFromPlace:place searchLocation:_location], is(notNilValue()));
    assertThat([_repository getRestaurantFromPlace:place searchLocation:_location], is(notNilValue()));

    assertThatUnsignedInt(_searchService.nrCallsToGetRestaurantForPlace, is(equalTo(@(1))));
}

- (void)test_getPlacesByCuisine_ShouldFlushCache_WhenCuisineChanges {
    CuisineAndOccasion *asian = [[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Asian" location:nil];
    CuisineAndOccasion *swiss = [[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:nil];

    [self.repository getPlacesBy:asian];
    [self.repository getPlacesBy:swiss];

    assertThatInt(_placesAPI.NrCallsToFindPlacesWasCalledWithCusine, equalTo(@2));
}

- (void)test_getPlacesByCuisine_ShouldFlushCache_WhenLocationChanges {
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:15.098 longitude:-50.56];
    CuisineAndOccasion *cuisine = [[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:location1];
    [self.repository getPlacesBy:cuisine];

    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:30 longitude:-20];
    CuisineAndOccasion *cuisine1 = [[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:location2];
    [self.repository getPlacesBy:cuisine1];

    assertThatInt(_placesAPI.NrCallsToFindPlacesWasCalledWithCusine, equalTo(@2));
}

- (void)test_getPlacesByCuisine_ShouldNotFlushCache_WhenLocationDoesNotChangeALot {

    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:52.631249 longitude:1.299053];
    CuisineAndOccasion *cuisine = [[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:location1];
    [self.repository getPlacesBy:cuisine];

    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:52.630813 longitude:1.299279];
    CuisineAndOccasion *cuisine1 = [[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:location2];
    [self.repository getPlacesBy:cuisine1];

    assertThatInt(_placesAPI.NrCallsToFindPlacesWasCalledWithCusine, equalTo(@1));
}


@end
