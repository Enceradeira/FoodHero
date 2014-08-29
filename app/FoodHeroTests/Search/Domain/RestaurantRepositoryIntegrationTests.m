//
//  RestaurantRepositoryTests.m
//  FoodHero
//
//  Created by Jorg on 18/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRepository.h"
#import "CLLocationManagerProxyStub.h"
#import "GoogleRestaurantSearch.h"
#import "PriceRange.h"
#import "RestaurantSearch.h"
#import "DistanceRange.h"
#import "ConversationSourceStub.h"

@interface RestaurantRepositoryIntegrationTests : XCTestCase

@end

@implementation RestaurantRepositoryIntegrationTests {
    ConversationSourceStub *_conversation;
    CLLocation *_norwich;
    CLLocation *_london;
    CLLocationManagerProxyStub *_locationManager;
    RestaurantRepository *_repository;
    LocationService *_locationService;
}

- (void)setUp {
    [super setUp];

    _conversation = [ConversationSourceStub new];

    _norwich = [[CLLocation alloc] initWithLatitude:52.631944 longitude:1.298889];
    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];

    _locationManager = [CLLocationManagerProxyStub new];
    _locationService = [[LocationService alloc] initWithLocationManager:_locationManager];
    _repository = [[RestaurantRepository alloc] initWithSearchService:[[GoogleRestaurantSearch alloc] init] locationService:_locationService];
}

- (void)test_getPlacesByCuisine_ShouldReturnCorrectlyInitializedPlaces {
    [_locationManager injectLocations:@[_london]];

    NSArray *places = [[_repository getPlacesByCuisine:@"Indian"] toArray][0];
    for(Place *p in places){
        CLLocationDistance distance = [p.location distanceFromLocation:_london];
        assertThatUnsignedInt(p.placeId.length, is(greaterThan(@0)));
        assertThatDouble(distance, is(greaterThan(@0)));
        assertThatDouble(distance, is(lessThan(@100000)));  // less than 100 km
    }

    // if everything works find we should find restaurants of all price-levels in London
    assertThatBool([places linq_any:^BOOL(Place *p){ return p.priceLevel == 0;}],is(equalToBool(YES)));
    assertThatBool([places linq_any:^BOOL(Place *p){ return p.priceLevel == 1;}],is(equalToBool(YES)));
    assertThatBool([places linq_any:^BOOL(Place *p){ return p.priceLevel == 2;}],is(equalToBool(YES)));
    assertThatBool([places linq_any:^BOOL(Place *p){ return p.priceLevel == 3;}],is(equalToBool(YES)));
    assertThatBool([places linq_any:^BOOL(Place *p){ return p.priceLevel == 4;}],is(equalToBool(YES)));

    // cuisineRelevance should be unique over all restaurants
    NSMutableArray *seenRelevances = [NSMutableArray new];
    for(Place *p in places){
        NSNumber *relevance = @(p.cuisineRelevance);
        bool isUnique = ![seenRelevances linq_any:^(NSNumber *otherRelevance){
            return (BOOL) [relevance isEqualToNumber: otherRelevance];
        }];
        assertThatBool(isUnique, is(equalToBool(YES)));
        [seenRelevances addObject:relevance];
    }

    // priceLevels between Places and Restaurant must be the same
    for(Place *p in places){
        Restaurant *r = [_repository getRestaurantFromPlace:p];
        assertThatUnsignedInt(r.priceLevel, is(equalTo(@(p.priceLevel))));
    }

    // cuisineRelevance between Places and Restaurant must be the same
    for(Place *p in places){
        Restaurant *r = [_repository getRestaurantFromPlace:p];
        assertThatDouble(r.cuisineRelevance, is(equalTo(@(p.cuisineRelevance))));
    }

}


- (void)test_searchAlgorithm {

    return;

    RestaurantSearch *search = [[RestaurantSearch alloc] initWithRestaurantRepository:_repository locationService:_locationService];

    [_locationManager injectLocations:@[_london]];

    PriceRange *priceRange = [PriceRange priceRangeWithoutRestriction];
    DistanceRange *distanceRange = [DistanceRange distanceRangeNearerThan:500 / DISTANCE_DECREMENT_FACTOR];

    [_conversation injectPriceRange:priceRange];
    [_conversation injectCuisine:@"India"];
    [_conversation injectMaxDistance:distanceRange];

    // Mint Leaf Restaurant & Bar Score: 1 Distance: 281.4368329282141 Price:3 Id: ChIJPVJVmNEEdkgRNtbDFaq89yM
    [self findAndLog:search];

    //[_conversation injectPriceRange:[priceRange setMinHigherThan:1]];
    [self findAndLog:search];

}

- (void)findAndLog:(RestaurantSearch *)search {
    Restaurant *r = [[search findBest:_conversation] toArray][0];
    NSLog(@"--------");
    NSLog([NSString stringWithFormat:@"Best is: %@ %@", r.name, r.placeId]);
}

@end
