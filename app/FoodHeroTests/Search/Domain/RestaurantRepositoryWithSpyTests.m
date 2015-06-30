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
#import "CLLocationManagerProxyStub.h"
#import "RestaurantRepository.h"
#import "RestaurantRepositoryTests.h"
#import "StubAssembly.h"
#import "RestaurantBuilder.h"

@interface RestaurantRepositoryWithSpyTests : RestaurantRepositoryTests

@end

@implementation RestaurantRepositoryWithSpyTests {
    RestaurantSearchServiceSpy *_searchService;
    RestaurantRepository *_repository;
    CuisineAndOccasion *_cuisineAndOccasion;
    CLLocation *_location;
}

- (void)setUp {
    [super setUp];
    [TyphoonComponents configure:[StubAssembly new]];

    _searchService = [RestaurantSearchServiceSpy new];

    id schedulerFactory = [[TyphoonComponents getAssembly] schedulerFactory];
    _repository = [[RestaurantRepository alloc] initWithSearchService:_searchService];
    _location = [[CLLocation alloc] initWithLatitude:12.6259 longitude:1.33212];
    _cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:_location];
}

- (RestaurantRepository *)repository {
    return _repository;
}

- (void)test_getPlacesBy {
    NSArray *result;
    result= [self.repository getPlacesBy:_cuisineAndOccasion];
    assertThat(_searchService.findPlacesParameter.cuisineAndOccasion, is(equalTo(_cuisineAndOccasion)));
}

- (void)test_getPlacesByCuisine_shouldSearchWithCurrentLocation {
    NSArray *result;
    result= [self.repository getPlacesBy:_cuisineAndOccasion];

    assertThatBool([_searchService findPlacesWasCalledWithLocation:_location.coordinate], is(@(YES)));
}

- (void)test_getRestaurantFromPlace_ShouldReturnRestaurantFromCache_WhenCalledMoreThanOnce {
    NSArray *result;
    result= [self.repository getPlacesBy:_cuisineAndOccasion]; // this queries the location which is a precondition for getRestaurantFromPlace

    Restaurant *place = [[RestaurantBuilder alloc] build];
    assertThat([_repository getRestaurantFromPlace:place], is(notNilValue()));
    assertThat([_repository getRestaurantFromPlace:place], is(notNilValue()));

    assertThatUnsignedInt(_searchService.nrCallsToGetRestaurantForPlace, is(equalTo(@(1))));
}

@end
