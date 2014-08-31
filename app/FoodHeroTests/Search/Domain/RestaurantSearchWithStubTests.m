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
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "RestaurantSearchTests.h"
#import "RestaurantBuilder.h"
#import "RestaurantRepositoryStub.h"
#import "CLLocationManagerProxyStub.h"
#import "DistanceRange.h"

@interface RestaurantSearchWithStubTests : RestaurantSearchTests

@end

@implementation RestaurantSearchWithStubTests {
    RestaurantSearch *_search;
    RestaurantRepositoryStub *_restaurantRepository;
    CLLocationManagerProxyStub *_locationManager;
}


- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _locationManager = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationManagerProxy];
    _restaurantRepository = [RestaurantRepositoryStub new];
    _search = [[RestaurantSearch alloc] initWithRestaurantRepository:_restaurantRepository locationService:[(id <ApplicationAssembly>) [TyphoonComponents factory] locationService]];
}

- (NSMutableArray *)restaurants:(NSInteger)nrRestaurants {
    NSMutableArray *restaurants = [NSMutableArray new];
    for (NSInteger i = 0; i < nrRestaurants; i++) {
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
    [_restaurantRepository injectRestaurants:@[place1, place2]];

    RACSignal *signal = [_search findBest:self.conversation];
    [signal subscribeNext:^(Restaurant *r) {
        restaurant = r;
    }];
    [signal subscribeCompleted:^() {
        completed = YES;
    }];
    [signal asynchronouslyWaitUntilCompleted:nil];

    assertThat(restaurant, is(notNilValue()));
    assertThatBool(completed, is(equalToBool(YES)));
}

- (void)test_findBest_ShouldNotReturnARestaurantThatTheUserDislikedBefore {
    Restaurant *restaurant1 = [[RestaurantBuilder alloc] build];
    Restaurant *restaurant2 = [[RestaurantBuilder alloc] build];
    [_restaurantRepository injectRestaurants:@[restaurant1, restaurant2]];

    Restaurant *firstRestaurant = [self findBest];

    [self conversationHasNegativeUserFeedback:[USuggestionFeedbackForNotLikingAtAll create:firstRestaurant]];

    assertThat([self findBest].placeId, isNot(equalTo(firstRestaurant.placeId)));
}

- (void)test_findBest_ShouldReturnRestaurantThatIsFurtherAway_WhenPriceLevelMatchesBetterAndItsNotThatFarAway {
    CLLocation *usersLocation = [[CLLocation alloc] initWithLatitude:52.633691 longitude:1.297240];
    CLLocation *veryCloseLocation = [[CLLocation alloc] initWithLatitude:usersLocation.coordinate.latitude + 0.001 longitude:usersLocation.coordinate.longitude + 0.001];
    CLLocation *closeLocation = [[CLLocation alloc] initWithLatitude:veryCloseLocation.coordinate.latitude + 0.001 longitude:veryCloseLocation.coordinate.longitude + 0.001];
    [_locationManager injectLocations:@[usersLocation]];

    Restaurant *priceLevel2Restaurant = [[[[RestaurantBuilder alloc] withPriceLevel:2] withLocation:closeLocation] build];
    Restaurant *priceLevel3Restaurant = [[[[RestaurantBuilder alloc] withPriceLevel:3] withLocation:veryCloseLocation] build];
    [_restaurantRepository injectRestaurants:@[priceLevel2Restaurant, priceLevel3Restaurant]];

    // user wishes cheaper than 3
    [self.conversation injectPriceRange:[[PriceRange priceRangeWithoutRestriction] setMaxLowerThan:3]];

    // best restaurant is priceLevel 2 because its the price-level matches and it's not that far away
    Restaurant *bestRestaurant = [self findBest];
    assertThat(bestRestaurant, is(equalTo(priceLevel2Restaurant)));
}

- (void)test_findBest_ShouldReturnRestaurantThatIsNearer_WhenPriceLevelMatchesWorseButOtherRestaurantItsTooFarAway {
    CLLocation *usersLocation = [[CLLocation alloc] initWithLatitude:52.633691 longitude:1.297240];
    CLLocation *closeLocation = [[CLLocation alloc] initWithLatitude:usersLocation.coordinate.latitude + 0.001 longitude:usersLocation.coordinate.longitude + 0.001];
    CLLocation *farAwayLocation = [[CLLocation alloc] initWithLatitude:closeLocation.coordinate.latitude + 1 longitude:closeLocation.coordinate.longitude + 1];
    [_locationManager injectLocations:@[usersLocation]];

    Restaurant *priceLevel2Restaurant = [[[[RestaurantBuilder alloc] withPriceLevel:2] withLocation:farAwayLocation] build];
    Restaurant *priceLevel3Restaurant = [[[[RestaurantBuilder alloc] withPriceLevel:3] withLocation:closeLocation] build];
    [_restaurantRepository injectRestaurants:@[priceLevel2Restaurant, priceLevel3Restaurant]];

    // user wishes cheaper than 3
    [self.conversation injectPriceRange:[[PriceRange priceRangeWithoutRestriction] setMaxLowerThan:3]];
    [self.conversation injectMaxDistance:[DistanceRange distanceRangeNearerThan:7500]];

    // best restaurant is priceLevel 3 because the priceLevel 2-Restaurant is too far away
    Restaurant *bestRestaurant = [self findBest];
    assertThat(bestRestaurant, is(equalTo(priceLevel3Restaurant)));
}

- (void)test_findBest_ShouldReturnNearestRestaurant_WhenPriceLevelsAreTheSame {
    Restaurant *nearerRestaurant = [[[RestaurantBuilder alloc] withName:@"Nearer restaurant"] build];
    Restaurant *otherRestaurant = [[[RestaurantBuilder alloc] withName:@"Other restaurant"] build];
    [_restaurantRepository injectRestaurants:@[nearerRestaurant, otherRestaurant]];

    Restaurant *bestRestaurant = [self findBest];
    assertThat(bestRestaurant, is(equalTo(nearerRestaurant)));
}

@end
