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
#import "RestaurantSearchServiceStub.h"
#import "RestaurantSearchServiceSpy.h"
#import "RestaurantSearch.h"
#import "CLLocationManagerProxyStub.h"
#import "RestaurantSearchTests.h"
#import "UCuisinePreference.h"

@interface RestaurantSearchWithSpyTests : RestaurantSearchTests

@end

@implementation RestaurantSearchWithSpyTests {
    RestaurantSearch *_search;
    RestaurantSearchServiceSpy *_searchService;
    CLLocationManagerProxyStub *_locationManagerStub;
    LocationService *_locationService;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];

    _searchService = [RestaurantSearchServiceSpy new];
    _locationManagerStub = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationManagerProxy];
    _locationService = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationService];
    _search = [[RestaurantSearch alloc] initWithSearchService:_searchService withLocationService:_locationService];
}

- (RestaurantSearch *)search {
    return _search;
}


- (void)test_findBest_shouldSearchWithCurrentLocation {
    CLLocationCoordinate2D location;
    location.latitude = 12.6259;
    location.longitude = 1.33212;

    [_locationManagerStub injectLatitude:location.latitude longitude:location.longitude];

    [self findBest];

    assertThatBool([_searchService findPlacesWasCalledWithLocation:location], is(equalToBool(YES)));
}

- (void)test_findBest_shouldSearchWithDesiredCuisine {
    [self conversationHasCuisine:@"Asian"];

    [self findBest];

    assertThat(_searchService.findPlacesParameter.cuisine, is(equalTo(@"Asian")));
}
@end