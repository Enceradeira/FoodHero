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
}

- (void)setUp {
    [super setUp];
    [TyphoonComponents configure:[StubAssembly new]];

    _searchService = [RestaurantSearchServiceSpy new];
    _locationManagerStub = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationManagerProxy];
    _locationService = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationService];

    id schedulerFactory = [(id <ApplicationAssembly>) [TyphoonComponents factory] schedulerFactory];
    _repository = [[RestaurantRepository alloc] initWithSearchService:_searchService locationService:_locationService schedulerFactory:schedulerFactory];
}

- (RestaurantRepository *)repository {
    return _repository;
}

- (NSArray *)getPlacesByCuisine:(NSString *)cuisine {
    __block NSMutableArray *places;
    RACSignal *signal = [_repository getPlacesByCuisine:cuisine];
    [signal subscribeNext:^(GooglePlace *r) {
        [places addObject:r];
    }];
    return places;
}

- (void)test_getPlacesByCuisine_ShouldSearchWithCuisine {
    [self getPlacesByCuisine:@"Swiss"];
    assertThat(_searchService.findPlacesParameter.cuisine, is(equalTo(@"Swiss")));
}

- (void)test_getPlacesByCuisine_shouldSearchWithCurrentLocation {
    CLLocationCoordinate2D location;
    location.latitude = 12.6259;
    location.longitude = 1.33212;

    [_locationManagerStub injectLatitude:location.latitude longitude:location.longitude];

    [self getPlacesByCuisine:@"Asian"];

    assertThatBool([_searchService findPlacesWasCalledWithLocation:location], is(@(YES)));
}

- (void)test_getRestaurantFromPlace_ShouldReturnRestaurantFromCache_WhenCalledMoreThanOnce {
    [self getPlacesByCuisine:@"Swiss"]; // this queries the location which is a precondition for getRestaurantFromPlace

    Restaurant *place = [[RestaurantBuilder alloc] build];
    assertThat([_repository getRestaurantFromPlace:place], is(notNilValue()));
    assertThat([_repository getRestaurantFromPlace:place], is(notNilValue()));

    assertThatUnsignedInt(_searchService.nrCallsToGetRestaurantForPlace, is(equalTo(@(1))));
}

@end
