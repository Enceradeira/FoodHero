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
#import <OCHamcrest/HCNumberAssert.h>
#import <OCHamcrest/HCIs.h>
#import "RestaurantRepository.h"
#import "CLLocationManagerProxyStub.h"
#import "GoogleRestaurantSearch.h"
#import "PriceRange.h"
#import "RestaurantSearch.h"
#import "DistanceRange.h"
#import "ConversationSourceStub.h"
#import "DefaultSchedulerFactory.h"
#import "AlwaysImmediateSchedulerFactory.h"

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

    id schedulerFactory = [AlwaysImmediateSchedulerFactory new];
    _locationManager = [CLLocationManagerProxyStub new];
    _locationService = [[LocationService alloc] initWithLocationManager:_locationManager schedulerFactory:schedulerFactory];

    _repository = [[RestaurantRepository alloc] initWithSearchService:[[GoogleRestaurantSearch alloc] init] locationService:_locationService schedulerFactory:schedulerFactory];
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

    // cuisineRelevance should be between 0..1
    for(Place *p in places){
        assertThatDouble(p.cuisineRelevance, is(greaterThanOrEqualTo(@0)));
        assertThatDouble(p.cuisineRelevance, is(lessThanOrEqualTo(@1)));
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

@end
