//
//  RestaurantSearchWithSpyTests.m
//  FoodHero
//
//  Created by Jorg on 14/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "RestaurantSearch.h"
#import "RestaurantSearchServiceStub.h"

@interface RestaurantSearchWithStubTests : XCTestCase

@end

@implementation RestaurantSearchWithStubTests {
        RestaurantSearch *_search;
    RestaurantSearchServiceStub *_searchServie;
}


- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _searchServie = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _search = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearch];
}

- (void)test_findBest_ShouldAlwaysReturnExactlyOneRestaurant {
    __block Restaurant *restaurant;
    __block BOOL completed;

    RACSignal *signal = [_search findBest:[NSArray new]];
    [signal subscribeNext:^(Restaurant *r) {
        restaurant = r;
    }];
    [signal subscribeCompleted:^() {
        completed = YES;
    }];

    assertThat(restaurant, is(notNilValue()));
    assertThatBool(completed, is(equalToBool(YES)));
}

@end
