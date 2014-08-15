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
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "RestaurantSearchTests.h"
#import "ConversationSourceStub.h"
#import "RestaurantBuilder.h"
#import "CLLocationManagerProxyStub.h"
#import "GoogleRestaurantSearch.h"
#import "RestaurantsAtRadius.h"

@interface RestaurantSearchWithStubTests : RestaurantSearchTests

@end

@implementation RestaurantSearchWithStubTests {
    RestaurantSearch *_search;
    RestaurantSearchServiceStub *_searchService;
    CLLocationManagerProxyStub *_locationManager;
}


- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _searchService = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _locationManager = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationManagerProxy];
    _search = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearch];
}

- (NSMutableArray *)restaurants:(int)nrRestaurants {
    NSMutableArray *restaurants = [NSMutableArray new];
    for (int i = 0; i < nrRestaurants; i++) {
        [restaurants addObject:[[RestaurantBuilder alloc] build]];
    }
    return restaurants;
}

- (RestaurantSearch *)search {
    return _search;
}

- (void)test_findBest_ShouldAlwaysReturnExactlyOneRestaurant {
    __block Restaurant *restaurant;
    __block BOOL completed;

    RACSignal *signal = [_search findBest:[ConversationSourceStub new]];
    [signal subscribeNext:^(Restaurant *r) {
        restaurant = r;
    }];
    [signal subscribeCompleted:^() {
        completed = YES;
    }];

    assertThat(restaurant, is(notNilValue()));
    assertThatBool(completed, is(equalToBool(YES)));
}

- (void)test_findBest_ShouldNotReturnARestaurantThatTheUserDislikedBefore {

    Restaurant *firstRestaurant = [self findBest];

    [self conversationHasNegativeUserFeedback:[USuggestionFeedbackForNotLikingAtAll create:firstRestaurant]];

    assertThat([self findBest].placeId, isNot(equalTo(firstRestaurant.placeId)));
}

- (void)test_findBest_ShouldReturnClosestRestaurant {
    CLLocation *currLocation = [[CLLocation alloc] initWithLatitude:45.0 longitude:45.0];
    [_locationManager injectLocations:@[currLocation]];

    Restaurant *restaurantFarAways = [[[RestaurantBuilder alloc] withLocation:[[CLLocation alloc] initWithLatitude:-45.0 longitude:72.0]] build];
    Restaurant *restaurantNearby = [[[RestaurantBuilder alloc] withLocation:[[CLLocation alloc] initWithLatitude:currLocation.coordinate.latitude+1 longitude:currLocation.coordinate.latitude-2]] build];

    [_searchService injectFindResults:@[restaurantFarAways, restaurantNearby]];

    Restaurant *restaurant = [self findBest];
    assertThat(restaurant, is(equalTo(restaurantNearby)));
}

- (void)test_findBest_ShouldDecreaseSearchRadius_WhenTwoManyRestaurantsFound {

    NSMutableArray *listWithMaxNrRestaurants = [self restaurants:GOOGLE_MAX_SEARCH_RESULTS];
    NSMutableArray *listWithLessRestaurants = [self restaurants:GOOGLE_MAX_SEARCH_RESULTS - 1];

    [_searchService injectFindResultsWithRadius:@[
            [RestaurantsAtRadius create:500 restaurants:@[]],
            [RestaurantsAtRadius create:GOOGLE_MAX_SEARCH_RADIUS / 3 restaurants:listWithLessRestaurants],
            [RestaurantsAtRadius create:GOOGLE_MAX_SEARCH_RADIUS restaurants:listWithMaxNrRestaurants]]];

    assertThat(listWithLessRestaurants, hasItem([self findBest]));
}


@end
