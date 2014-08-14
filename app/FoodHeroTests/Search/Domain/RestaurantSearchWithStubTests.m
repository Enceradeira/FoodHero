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

@interface RestaurantSearchWithStubTests : XCTestCase

@end

@implementation RestaurantSearchWithStubTests {
    RestaurantSearch *_search;
    RestaurantSearchServiceStub *_searchService;
    NSMutableArray *_userFeedback;
}


- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _searchService = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _search = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearch];
    _userFeedback = [NSMutableArray new];
}

- (Restaurant *)findBest {
    __block Restaurant *restaurant;
    RACSignal *signal = [_search findBest:_userFeedback];
    [signal subscribeNext:^(Restaurant *r) {
        restaurant = r;
    }];
    return restaurant;
}

- (void)feedbackIsFeedback:(USuggestionFeedbackForNotLikingAtAll *)feedback {
    [_userFeedback addObject:feedback];
}

- (void)test_findBest_ShouldAlwaysReturnExactlyOneRestaurant {
    __block Restaurant *restaurant;
    __block BOOL completed;

    RACSignal *signal = [_search findBest:_userFeedback];
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

    [self feedbackIsFeedback:[USuggestionFeedbackForNotLikingAtAll create:firstRestaurant]];

    Restaurant *secondRestaurant = [self findBest];
    assertThat(firstRestaurant.placeId, isNot(equalTo(secondRestaurant.placeId)));
}


@end
