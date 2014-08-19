//
//  RestaurantSearchWithSpyTests.m
//  FoodHero
//
//  Created by Jorg on 14/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "XCTestCase+AsyncTesting.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "RestaurantSearch.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "RestaurantSearchTests.h"
#import "RestaurantBuilder.h"
#import "RestaurantRepositoryStub.h"

@interface RestaurantSearchWithStubTests : RestaurantSearchTests

@end

@implementation RestaurantSearchWithStubTests {
    RestaurantSearch *_search;
    RestaurantRepositoryStub *_restaurantRepository;
}


- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _restaurantRepository = [RestaurantRepositoryStub new];
    _search = [[RestaurantSearch alloc] initWithRestaurantRepository:_restaurantRepository];
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

    Restaurant *place1 = [[RestaurantBuilder alloc] build];
    Restaurant *place2 = [[RestaurantBuilder alloc] build];
    [_restaurantRepository injectRestaurantsByCuisineOrderedByDistance:@[place1, place2]];

    RACSignal *signal = [_search findBest:self.conversation];
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
    Restaurant *restaurant1 = [[RestaurantBuilder alloc] build];
    Restaurant *restaurant2 = [[RestaurantBuilder alloc] build];
    [_restaurantRepository injectRestaurantsByCuisineOrderedByDistance:@[restaurant1, restaurant2]];

    Restaurant *firstRestaurant = [self findBest];

    [self conversationHasNegativeUserFeedback:[USuggestionFeedbackForNotLikingAtAll create:firstRestaurant]];

    assertThat([self findBest].placeId, isNot(equalTo(firstRestaurant.placeId)));
}
@end
