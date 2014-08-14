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

    Restaurant *r1 = [[[RestaurantBuilder alloc] withLocation:[[CLLocation alloc] initWithLatitude:-45.0 longitude:72.0]] build];
    Restaurant *r2 = [[[RestaurantBuilder alloc] withLocation:[[CLLocation alloc] initWithLatitude:46.2 longitude:40.0]] build];

    [_searchService injectFindResults:@[r2, r1]];

    Restaurant *restaurant = [self findBest];
    assertThat(restaurant, is(equalTo(r1)));
}


@end
