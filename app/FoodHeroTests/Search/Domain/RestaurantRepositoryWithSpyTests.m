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
#import "FoodHero-Swift.h"

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

- (void)test_getPlacesBy {
    NSArray *result;
    result = [self.repository getPlacesBy:_cuisineAndOccasion];
    assertThat(_searchService.findPlacesParameter.cuisineAndOccasion, is(equalTo(_cuisineAndOccasion)));
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

@end
