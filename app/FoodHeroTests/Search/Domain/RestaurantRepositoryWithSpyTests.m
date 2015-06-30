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
    CLLocationManagerProxyStub *_locationManagerStub;
    LocationService *_locationService;
    RestaurantRepository *_repository;
    CuisineAndOccasion *_cuisineAndOccasion;
}

- (void)setUp {
    [super setUp];
    [TyphoonComponents configure:[StubAssembly new]];

    _searchService = [RestaurantSearchServiceSpy new];
    _locationManagerStub = [[TyphoonComponents getAssembly] locationManagerProxy];
    _locationService = [[TyphoonComponents getAssembly] locationService];

    id schedulerFactory = [[TyphoonComponents getAssembly] schedulerFactory];
    _repository = [[RestaurantRepository alloc] initWithSearchService:_searchService locationService:_locationService schedulerFactory:schedulerFactory];
    _cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:@"brunch" cuisine:@"Swiss" location:nil];
}

- (RestaurantRepository *)repository {
    return _repository;
}

- (NSArray *)getPlacesBy:(CuisineAndOccasion *)cuisine {
    __block NSMutableArray *places;
    RACSignal *signal = [_repository getPlacesBy:cuisine];
    [signal subscribeNext:^(GooglePlace *r) {
        [places addObject:r];
    }];
    return places;
}

- (void)test_getPlacesBy {
    [self getPlacesBy:_cuisineAndOccasion];
    assertThat(_searchService.findPlacesParameter.cuisineAndOccasion, is(equalTo(_cuisineAndOccasion)));
}

- (void)test_getPlacesByCuisine_shouldSearchWithCurrentLocation {
    CLLocationCoordinate2D location;
    location.latitude = 12.6259;
    location.longitude = 1.33212;

    [_locationManagerStub injectLatitude:location.latitude longitude:location.longitude];

    [self getPlacesBy:_cuisineAndOccasion];

    assertThatBool([_searchService findPlacesWasCalledWithLocation:location], is(@(YES)));
}

- (void)test_getRestaurantFromPlace_ShouldReturnRestaurantFromCache_WhenCalledMoreThanOnce {
    [self getPlacesBy:_cuisineAndOccasion]; // this queries the location which is a precondition for getRestaurantFromPlace

    Restaurant *place = [[RestaurantBuilder alloc] build];
    assertThat([_repository getRestaurantFromPlace:place], is(notNilValue()));
    assertThat([_repository getRestaurantFromPlace:place], is(notNilValue()));

    assertThatUnsignedInt(_searchService.nrCallsToGetRestaurantForPlace, is(equalTo(@(1))));
}

@end
