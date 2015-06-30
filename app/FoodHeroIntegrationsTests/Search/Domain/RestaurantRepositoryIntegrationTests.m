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
#import "TyphoonComponents.h"

@interface RestaurantRepositoryIntegrationTests : XCTestCase

@end

@implementation RestaurantRepositoryIntegrationTests {
    ConversationSourceStub *_conversation;
    CLLocation *_norwich;
    CLLocation *_london;
    RestaurantRepository *_repository;
}

- (void)setUp {
    [super setUp];

    _conversation = [ConversationSourceStub new];

    _norwich = [[CLLocation alloc] initWithLatitude:52.631944 longitude:1.298889];
    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];

    id schedulerFactory = [AlwaysImmediateSchedulerFactory new];

    id <RestaurantSearchService> restaurantSearch = [[TyphoonComponents getAssembly] restaurantSearchService];
    _repository = [[RestaurantRepository alloc] initWithSearchService:restaurantSearch];
}

- (void)test_getPlacesByCuisine_ShouldReturnCorrectlyInitializedPlaces {

    CuisineAndOccasion *cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:[Occasions lunch] cuisine:@"Indian" location:_london];
    NSArray *places = [_repository getPlacesBy:cuisineAndOccasion];
    for(Place *p in places){
        CLLocationDistance distance = [p.location distanceFromLocation:_london];
        assertThatUnsignedInt(p.placeId.length, is(greaterThan(@0)));
        assertThatDouble(distance, is(greaterThan(@0)));
        assertThatDouble(distance, is(lessThan(@100000)));  // less than 100 km
    }

    // if everything works find we should find restaurants of all price-levels in London
    assertThatBool([places linq_any:^BOOL(Place *p){ return p.priceLevel == 0;}],is(equalTo(@YES)));
    assertThatBool([places linq_any:^BOOL(Place *p){ return p.priceLevel == 1;}],is(equalTo(@YES)));
    assertThatBool([places linq_any:^BOOL(Place *p){ return p.priceLevel == 2;}],is(equalTo(@YES)));
    assertThatBool([places linq_any:^BOOL(Place *p){ return p.priceLevel == 3;}],is(equalTo(@YES)));
    assertThatBool([places linq_any:^BOOL(Place *p){ return p.priceLevel == 4;}],is(equalTo(@YES)));

    // cuisineRelevance should be unique over all restaurants
    NSMutableArray *seenRelevances = [NSMutableArray new];
    for(Place *p in places){
        NSNumber *relevance = @(p.cuisineRelevance);
        bool isUnique = ![seenRelevances linq_any:^(NSNumber *otherRelevance){
            return (BOOL) [relevance isEqualToNumber: otherRelevance];
        }];
        assertThatBool(isUnique, is(equalTo(@YES)));
        [seenRelevances addObject:relevance];
    }

    // cuisineRelevance should be between 0..1
    for(Place *p in places){
        assertThatDouble(p.cuisineRelevance, is(greaterThanOrEqualTo(@0)));
        assertThatDouble(p.cuisineRelevance, is(lessThanOrEqualTo(@1)));
    }

    // priceLevels between Places and Restaurant must be the same
    for(Place *p in places){
        Restaurant *r = [_repository getRestaurantFromPlace:p currentLocation:_norwich];
        assertThatUnsignedInt(r.priceLevel, is(equalTo(@(p.priceLevel))));
    }

    // cuisineRelevance between Places and Restaurant must be the same
    for(Place *p in places){
        Restaurant *r = [_repository getRestaurantFromPlace:p currentLocation:_norwich];
        assertThatDouble(r.cuisineRelevance, is(equalTo(@(p.cuisineRelevance))));
    }

}

@end
