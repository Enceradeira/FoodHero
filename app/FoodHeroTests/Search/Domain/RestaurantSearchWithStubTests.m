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

@interface RestaurantSearchWithStubTests : RestaurantSearchTests

@end

@implementation RestaurantSearchWithStubTests {
    RestaurantSearch *_search;
    RestaurantSearchServiceStub *_searchService;

}


- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _searchService = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _search = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearch];
}

- (RestaurantSearch *)search {
    return _search;
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

- (void)test_findBest_ShouldNotReturnARestaurnatThatTheUserDislikedBefore {

    Restaurant *firstRestaurant = [self findBest];

    [self feedbackIs:[USuggestionFeedbackForNotLikingAtAll create:firstRestaurant]];

    assertThat([self findBest].placeId, isNot(equalTo(firstRestaurant.placeId)));
}


@end
