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

@interface RestaurantSearchWithSpyTests : RestaurantSearchTests

@end

@implementation RestaurantSearchWithSpyTests {
    RestaurantSearch *_search;
    RestaurantRepositorySpy *_restaurantRepository;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];

    _restaurantRepository = [RestaurantRepositorySpy new];
    id schedulerFactory = [(id <ApplicationAssembly>) [TyphoonComponents getAssembly] schedulerFactory];
    id locationService = [(id <ApplicationAssembly>) [TyphoonComponents getAssembly] locationService];
    _search = [[RestaurantSearch alloc] initWithRestaurantRepository:_restaurantRepository locationService:locationService schedulerFactory:schedulerFactory];
}

- (RestaurantSearch *)search {
    return _search;
}

- (void)test_findBest_shouldSearchWithDesiredCuisine {
    [self conversationHasCuisine:@"Asian"];

    [self findBest];

    assertThat(_restaurantRepository.getPlacesByCuisineParameter.cuisine, is(equalTo(@"Asian")));
}

@end