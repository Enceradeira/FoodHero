//
//  FHConversationStateTests.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "DefaultAssembly.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "RestaurantSearch.h"
#import "RestaurantSearchTests.h"
#import "RestaurantRepositorySpy.h"
#import "CLLocationManagerProxyStub.h"

@interface RestaurantSearchWithSpyTests : RestaurantSearchTests

@end

@implementation RestaurantSearchWithSpyTests {
    RestaurantSearch *_search;
    RestaurantRepositorySpy *_restaurantRepository;
    GeocoderServiceStub *_geocoderServiceStub;
    CLLocation *_locationNorwich;
    CLLocationManagerProxyStub *_locationManagerStub;
    CLLocation *_currentLocation;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];

    _locationNorwich = [[CLLocation alloc] initWithLatitude:52.631944 longitude:1.298889];
    _currentLocation = [[CLLocation alloc] initWithLatitude:50.44587 longitude:-9.55487];

    _restaurantRepository = [RestaurantRepositorySpy new];
    id schedulerFactory = [[TyphoonComponents getAssembly] schedulerFactory];
    id locationService = [[TyphoonComponents getAssembly] locationService];
    _locationManagerStub = (CLLocationManagerProxyStub *) [[TyphoonComponents getAssembly] locationManagerProxy];
    _geocoderServiceStub = (GeocoderServiceStub * )[[TyphoonComponents getAssembly] geocoderService];
    _search = [[RestaurantSearch alloc] initWithRestaurantRepository:_restaurantRepository
                                                     locationService:locationService
                                                    schedulerFactory:schedulerFactory
                                                     geocoderService:_geocoderServiceStub];
}

- (RestaurantSearch *)search {
    return _search;
}

- (void)test_findBest_shouldSearchWithDesiredCuisine {
    [self conversationHasCuisine:@"Asian"];

    [self findBest];

    assertThat(_restaurantRepository.getPlacesByCuisineParameter.cuisine, is(equalTo(@"Asian")));
}

- (void)test_findBest_ShouldSearchWithPreferredLocation_WhenPreferredLocationCanBeResolved {
    [self conversationHasCurrentSearchLocation:@"Norwich City Center"];
    [_geocoderServiceStub injectLocation:_locationNorwich];
    [_locationManagerStub injectLocations:@[_currentLocation]];

    [self findBest];

    assertThat(_geocoderServiceStub.geocodeAddressStringParameter, is(equalTo(@"Norwich City Center")));
    assertThat(_restaurantRepository.getPlacesByCuisineParameter.location, is(equalTo(_locationNorwich)));
}

- (void)test_findBest_ShouldSearchWithCurrentLocation_WhenPreferredLocationCantBeResolved {
    [self conversationHasCurrentSearchLocation:@"Norwich City Center"];
    [_geocoderServiceStub injectLocation:nil];
    [_locationManagerStub injectLocations:@[_currentLocation]];

    [self findBest];

    assertThat(_restaurantRepository.getPlacesByCuisineParameter.location, is(equalTo(_currentLocation)));
}

- (void)test_findBest_ShouldSearchWithCurrentLocation_WhenPreferredLocationNil {
    [self conversationHasCurrentSearchLocation:nil];
    [_geocoderServiceStub injectLocation:_locationNorwich];
    [_locationManagerStub injectLocations:@[_currentLocation]];

    [self findBest];

    assertThat(_restaurantRepository.getPlacesByCuisineParameter.location, is(equalTo(_currentLocation)));
}

- (void)test_findBest_ShouldSearchWithCurrentLocation_WhenPreferredLocationEmpty {
    [self conversationHasCurrentSearchLocation:@""];
    [_geocoderServiceStub injectLocation:_locationNorwich];
    [_locationManagerStub injectLocations:@[_currentLocation]];

    [self findBest];

    assertThat(_restaurantRepository.getPlacesByCuisineParameter.location, is(equalTo(_currentLocation)));
}

@end