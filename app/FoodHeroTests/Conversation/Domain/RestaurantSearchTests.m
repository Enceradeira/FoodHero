 //
//  ConversationTests.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND

#import <OCHamcrest/OCHamcrest.h>
#import "Personas.h"
#import "DefaultAssembly.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "RestaurantSearchServiceStub.h"
#import "LocationServiceStub.h"
#import "RestaurantSearchServiceSpy.h"
#import "RestaurantSearch.h"

@interface RestaurantSearchTests : XCTestCase

@end

@implementation RestaurantSearchTests {
    RestaurantSearch *_restaurantSearch;
    RestaurantSearchServiceSpy *_searchService;
    LocationServiceStub *_locationService;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];

    _searchService = [RestaurantSearchServiceSpy new];
    _locationService = [LocationServiceStub new];
    _restaurantSearch = [[RestaurantSearch alloc] initWithSearchService:_searchService withLocationService:_locationService];
}

- (void)test_findBest_shouldSearchWithCurrentLocation {
    CLLocationCoordinate2D location;
    location.latitude =    12.6259;
    location.longitude = 1.33212;
    
    [_locationService injectLocation:location];

    [_restaurantSearch findBest];

    assertThatBool([_searchService findWasCalledWithLocation:location], is(equalToBool(YES)));
}

@end