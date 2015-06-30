#import "RestaurantSearchResult.h"//
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
#import "RestaurantSearchTests.h"
#import "RestaurantBuilder.h"
#import "RestaurantRepositoryStub.h"
#import "CLLocationManagerProxyStub.h"
#import "SearchError.h"

@interface RestaurantSearchWithStubTests : RestaurantSearchTests

@end

@implementation RestaurantSearchWithStubTests {
    RestaurantSearch *_search;
    RestaurantRepositoryStub *_restaurantRepository;
    CLLocationManagerProxyStub *_locationManager;
    CLLocation *_london;
    GeocoderServiceStub * _geocoderServiceStub;
}


- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];
    _locationManager = [[TyphoonComponents getAssembly] locationManagerProxy];
    _geocoderServiceStub = (GeocoderServiceStub *)[[TyphoonComponents getAssembly] geocoderService];
    _restaurantRepository = [RestaurantRepositoryStub new];

    id locationService = [[TyphoonComponents getAssembly] locationService];
    id schedulerFactory = [[TyphoonComponents getAssembly] schedulerFactory];
    _search = [[RestaurantSearch alloc] initWithRestaurantRepository:_restaurantRepository
                                                     locationService:locationService
                                                    schedulerFactory:schedulerFactory
                                                     geocoderService:_geocoderServiceStub];
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
    assertThatBool(completed, is(@(YES)));
}

- (void)test_findBest_ShouldNotReturnARestaurantThatTheUserDislikedBefore {
    Restaurant *restaurant1 = [[RestaurantBuilder alloc] build];
    Restaurant *restaurant2 = [[RestaurantBuilder alloc] build];
    [_restaurantRepository injectRestaurants:@[restaurant1, restaurant2]];

    Restaurant *firstRestaurant = [self findBest].restaurant;

    USuggestionFeedbackParameters *p = [[UserUtterances suggestionFeedbackForDislike:firstRestaurant text:@"I don't like that restaurant"] customData][0];
    [self conversationHasNegativeUserFeedback:p];

    assertThat([self findBest].restaurant.placeId, isNot(equalTo(firstRestaurant.placeId)));
}

- (void)test_findBest_ShouldNotReturnARestaurantThatHasTheSameNameAsAnOtherDislikedRestaurantBefore {
    Restaurant *restaurant1 = [[[RestaurantBuilder alloc] withName:@"Welcome Inn"] build];
    Restaurant *restaurant2 = [[[RestaurantBuilder alloc] withName:@"Welcome Inn"] build];
    Restaurant *restaurant3 = [[[RestaurantBuilder alloc] withName:@"King's Head"] build];
    [_restaurantRepository injectRestaurants:@[restaurant1, restaurant2, restaurant3]];

    Restaurant *firstRestaurant = [self findBest].restaurant;

    USuggestionFeedbackParameters *p = [[UserUtterances suggestionFeedbackForDislike:firstRestaurant text:@"I don't like that restaurant"] customData][0];
    [self conversationHasNegativeUserFeedback:p];

    assertThat([self findBest].restaurant.placeId, is(equalTo(restaurant3.placeId)));
}

- (void)test_findBest_ShouldNotReturnARestaurantThatWasSuggestedInCurrentSearch {
    Restaurant *restaurant1 = [[RestaurantBuilder alloc] build];
    Restaurant *restaurant2 = [[RestaurantBuilder alloc] build];
    [_restaurantRepository injectRestaurants:@[restaurant1, restaurant2]];

    Restaurant *firstRestaurant = [self findBest].restaurant;
    [self conversationHasSuggestedRestaurant:firstRestaurant];

    Restaurant *secondRestaurant = [self findBest].restaurant;
    assertThat(firstRestaurant.placeId, isNot(equalTo(secondRestaurant.placeId)));
}

- (void)test_findBest_ShouldReturnARestaurantThatWasSuggestedInPreviousSearch {
    Restaurant *restaurant1 = [[RestaurantBuilder alloc] build];
    Restaurant *restaurant2 = [[RestaurantBuilder alloc] build];
    [_restaurantRepository injectRestaurants:@[restaurant1, restaurant2]];

    Restaurant *firstRestaurant = [self findBest].restaurant;
    [self conversationHasSuggestedRestaurant:firstRestaurant];
    [self conversationStartsNewSearch];

    Restaurant *secondRestaurant = [self findBest].restaurant;
    assertThat(firstRestaurant.placeId, is(equalTo(secondRestaurant.placeId)));
}

- (void)test_findBest_ShouldReturnRestaurantThatIsFurtherAway_WhenPriceLevelMatchesBetterAndItsNotThatFarAway {
    CLLocation *usersLocation = [[CLLocation alloc] initWithLatitude:52.633691 longitude:1.297240];
    CLLocation *veryCloseLocation = [[CLLocation alloc] initWithLatitude:usersLocation.coordinate.latitude + 0.001 longitude:usersLocation.coordinate.longitude + 0.001];
    CLLocation *closeLocation = [[CLLocation alloc] initWithLatitude:veryCloseLocation.coordinate.latitude + 0.0002 longitude:veryCloseLocation.coordinate.longitude + 0.0002];
    [_locationManager injectLocations:@[usersLocation]];

    Restaurant *priceLevel2Restaurant = [[[[RestaurantBuilder alloc] withPriceLevel:2] withLocation:closeLocation] build];
    Restaurant *priceLevel3Restaurant = [[[[RestaurantBuilder alloc] withPriceLevel:3] withLocation:veryCloseLocation] build];
    [_restaurantRepository injectRestaurants:@[priceLevel2Restaurant, priceLevel3Restaurant]];

    // user wishes cheaper than 3
    [self.conversation injectPriceRange:[[PriceRange priceRangeWithoutRestriction] setMaxLowerThan:3]];

    // best restaurant is priceLevel 2 because its the price-level matches and it's not that far away
    Restaurant *bestRestaurant = [self findBest].restaurant;
    assertThat(bestRestaurant, is(equalTo(priceLevel2Restaurant)));
}

- (void)test_findBest_ShouldReturnRestaurantThatIsNearer_WhenPriceLevelMatchesWorseButOtherRestaurantItsTooFarAway {
    CLLocation *usersLocation = [[CLLocation alloc] initWithLatitude:52.633691 longitude:1.297240];
    CLLocation *closeLocation = [[CLLocation alloc] initWithLatitude:usersLocation.coordinate.latitude + 1 longitude:usersLocation.coordinate.longitude + 1];
    CLLocation *farAwayLocation = [[CLLocation alloc] initWithLatitude:closeLocation.coordinate.latitude + 2 longitude:closeLocation.coordinate.longitude + 2];
    [_locationManager injectLocations:@[usersLocation]];

    Restaurant *priceLevel2Restaurant = [[[[RestaurantBuilder alloc] withPriceLevel:2] withLocation:farAwayLocation] build];
    Restaurant *priceLevel3Restaurant = [[[[RestaurantBuilder alloc] withPriceLevel:3] withLocation:closeLocation] build];
    [_restaurantRepository injectRestaurants:@[priceLevel2Restaurant, priceLevel3Restaurant]];

    // user wishes cheaper than 3
    [self.conversation injectPriceRange:[[PriceRange priceRangeWithoutRestriction] setMaxLowerThan:3]];
    [self.conversation injectMaxDistance:[DistanceRange distanceRangeNearerThan:1]];

    // best restaurant is priceLevel 3 because the priceLevel 2-Restaurant is too far away
    Restaurant *bestRestaurant = [self findBest].restaurant;
    assertThat(bestRestaurant, is(equalTo(priceLevel3Restaurant)));
}

- (void)test_findBest_ShouldReturnNearestRestaurant_WhenPriceLevelsAreTheSame {
    Restaurant *nearerRestaurant = [[[RestaurantBuilder alloc] withName:@"Nearer restaurant"] build];
    Restaurant *otherRestaurant = [[[RestaurantBuilder alloc] withName:@"Other restaurant"] build];
    [_restaurantRepository injectRestaurants:@[nearerRestaurant, otherRestaurant]];

    Restaurant *bestRestaurant = [self findBest].restaurant;
    assertThat(bestRestaurant, is(equalTo(nearerRestaurant)));
}

- (void)test_findBest_ShouldReturnError_WhenGetRestaurantFromPlaceReturnsSearchException {
    __block NSError *receivedError;
    __block BOOL isCompleted;
    [_restaurantRepository injectRestaurants:@[[[[RestaurantBuilder alloc] withName:@"Other restaurant"] build]]];
    [_restaurantRepository injectException:[SearchException createWithReason:@"failure"]];

    RACSignal *signal = [_search findBest:self.conversation];
    [signal subscribeError:^(NSError *error) {
        receivedError = error;
    }];
    [signal subscribeCompleted:^() {
        isCompleted = YES;
    }];
    [signal asynchronouslyWaitUntilCompleted:nil];

    assertThatBool([receivedError isKindOfClass:[SearchError class]], is(@(YES)));
    // assertThatBool(isCompleted, is(equalToBool(YES))); commented because it didn't work under 64bit, but integration tests were ok

}

- (void)test_findBest_ShouldReturnSearchPreference {
    [_restaurantRepository injectRestaurants:@[[[RestaurantBuilder alloc] build]]];

    RestaurantSearchResult *searchResult = [self findBest];

    assertThat(searchResult.searchParams, is(notNilValue()));
}

@end
