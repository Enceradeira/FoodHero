//
//  GoogleRestaurantSearchTests.m
//  FoodHero
//
//  Created by Jorg on 08/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "GoogleRestaurantSearch.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"
#import "SearchException.h"
#import "IPhoto.h"
#import "GoogleDefinitions.h"
#import "TyphoonComponents.h"
#import "FoodHero-Swift.h"

@interface GoogleRestaurantSearchTests : XCTestCase

@end

@implementation GoogleRestaurantSearchTests {
    GoogleRestaurantSearch *_service;
    RestaurantSearchParams *_parameter;
    NSString *_placeIdLibraryGrillNorwich;
    NSString *_placeIdMaidsHeadNorwich;
    CLLocation *_norwich;
    CLLocation *_london;
    NSString *_placeIdVeeraswamyLondon;
    NSString *_placeIdEveningRiverCruiseYork;
    id <ApplicationAssembly> _assembly;
}

- (void)setUp {
    [super setUp];

    _placeIdLibraryGrillNorwich = @"ChIJZzNZ0-Dj2UcRn1Eq2l80nbw";
    _placeIdMaidsHeadNorwich = @"ChIJicLqAOjj2UcR1qA1_M1zFRI";
    _placeIdVeeraswamyLondon = @"ChIJnVRkK9QEdkgRz8uiqq2HfjM";
    _placeIdEveningRiverCruiseYork = @"ChIJh_uMeqYxeUgR0_Wzw6fzne4";


    // Maids Head Hotel, Tombland, Norwich
    _norwich = [[CLLocation alloc] initWithLatitude:52.631944 longitude:1.298889];
    _london = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];

    _parameter = [RestaurantSearchParams new];
    _parameter.coordinate = _norwich.coordinate;
    _parameter.radius = 10000;
    _parameter.cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:[Occasions dinner] cuisine:@"Indian"];

    _assembly = [TyphoonComponents getAssembly];
    _service = [[GoogleRestaurantSearch alloc] initWithEnvironment:[_assembly environment] onlyOpenNow:false /*otherwise tests become unstable*/ ];
}

- (GooglePlace *)findPlaceById:(NSString *)idLibraryGrillNorwich result:(NSArray *)result {
    return [[result linq_where:^(GooglePlace *place) {
        return [place.placeId isEqualToString:idLibraryGrillNorwich];
    }] linq_firstOrNil];
}

- (void)test_findPlaces_ShouldReturnPlacesWithMatchingCuisineFirst {
    _parameter.cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:[Occasions dinner] cuisine:@"Steak house"];
    NSArray *places = [_service findPlaces:_parameter];

    // cuisineRelevance should become smaller when iterating through the results
    GooglePlace *firstPlace = (GooglePlace *) places[0];
    GooglePlace *lastPlace = (GooglePlace *) places[places.count - 1];
    assertThatDouble(firstPlace.cuisineRelevance, is(equalTo(@(1))));
    assertThatDouble(lastPlace.cuisineRelevance, is(lessThan(@(1))));

    for (NSUInteger i = 1; i < places.count; i++) {
        GooglePlace *prevPlace = places[i - 1];
        GooglePlace *nextPlace = places[i];
        assertThatDouble(prevPlace.cuisineRelevance, is(greaterThan(@(nextPlace.cuisineRelevance))));
    }
}

- (void)test_findPlaces_ShouldReturnCuisineRelevance0ForMostIrrelevantPlace_WhenSearchRadiusEqualMaxSearchRadius {
    _parameter.radius = GOOGLE_MAX_SEARCH_RADIUS;
    GooglePlace *mostIrrelevantPlace = [[_service findPlaces:_parameter] linq_lastOrNil];

    assertThatDouble(mostIrrelevantPlace.cuisineRelevance, is(equalTo(@0)));
}

- (void)test_findPlaces_ShouldReturnSomething_WhenOnlyPlacesOpenNowAreSearched {
    _parameter.radius = GOOGLE_MAX_SEARCH_RADIUS;
    _parameter.cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:[Occasions dinner] cuisine:@""];
    _service = [[GoogleRestaurantSearch alloc] initWithEnvironment:[_assembly environment] onlyOpenNow:true];

    NSArray *result = [_service findPlaces:_parameter];

    assertThatDouble(result.count, is(greaterThan(@(0))));
}

- (void)test_findPlaces_ShouldReturnCuisineRelevanceGreaterThan0ForMostIrrelevantPlace_WhenSearchRadiusLessThanMaxSearchRadius {
    _parameter.radius = GOOGLE_MAX_SEARCH_RADIUS / 2;
    _parameter.cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:[Occasions dinner] cuisine:@"French"];
    GooglePlace *mostIrrelevantPlace = [[_service findPlaces:_parameter] linq_lastOrNil];

    assertThatDouble(mostIrrelevantPlace.cuisineRelevance, is(greaterThan(@0)));
}

- (void)test_search_manually {
    return; // ignored

    CLLocation *york = [[CLLocation alloc] initWithLatitude:53.963367 longitude:-1.122695];
    _parameter.radius = GOOGLE_MAX_SEARCH_RADIUS;
    _parameter.cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:[Occasions dinner] cuisine:@"cheese fondue"];
    _parameter.coordinate = _london.coordinate;
    NSArray *places = [_service findPlaces:_parameter];
    for (NSUInteger i = 1; i < places.count && i < 20; i++) {
        Restaurant *restaurant = [_service getRestaurantForPlace:places[i] currentLocation:york];
        NSLog(@"Name: %@ Vicinity: %@", restaurant.name, restaurant.vicinity);
    }
}

- (void)test_findPlaces_ShouldReturnPlacesWithinSpecifiedRadius {
    NSInteger specifiedRadius = 200;

    _parameter.cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:[Occasions dinner] cuisine:@"Indian"];
    _parameter.radius = specifiedRadius;
    _parameter.coordinate = _norwich.coordinate;

    NSArray *places = [_service findPlaces:_parameter];
    assertThatUnsignedInt(places.count, is(greaterThan(@(1))));
    for (GooglePlace *place in places) {
        CLLocationDistance distance = [_norwich distanceFromLocation:place.location];
        assertThatDouble(distance, is(lessThanOrEqualTo(@(specifiedRadius * 3))));
    }
}

- (void)test_findPlaces_ShouldReturnPlacesWithinSpecifiedPriceRange {
    _parameter.cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:[Occasions dinner] cuisine:@"Indian"];
    _parameter.radius = 5000;
    _parameter.coordinate = _london.coordinate;  // only london supports price range at the moment
    _parameter.minPriceLevel = 4;
    _parameter.maxPriceLevel = 4;

    NSArray *places = [[_service findPlaces:_parameter] linq_take:5];  // test on 5 places, not all 200
    assertThatUnsignedInt(places.count, is(greaterThan(@(1))));
    for (GooglePlace *place in places) {
        Restaurant *restaurant = [_service getRestaurantForPlace:place currentLocation:_norwich];
        assertThatUnsignedInt(restaurant.priceLevel, is(equalTo(@4)));
    }
}

- (void)test_findPlaces_ShouldThrowException_WhenRadiusGreaterThanMaxSearchRadius {
    _parameter.radius = GOOGLE_MAX_SEARCH_RADIUS + 1;
    assertThat(^() {
        [_service findPlaces:_parameter];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_findPlaces_ShouldThrowException_WhenThereIsANetworkingError {
    _service.baseAddress = @"https://jennius.com"; // this should throw a networking error since no search is available at this address
    _service.timeout = 0.1;

    assertThat(^() {
        [_service findPlaces:_parameter];
    }, throwsExceptionOfType([SearchException class]));
}

- (void)test_getRestaurantForPlace_ShouldThrowException_WhenThereIsANetworkingError {
    _service.baseAddress = @"https://jennius.com"; // this should throw a networking error since no search is available at this address
    _service.timeout = 0.1;

    assertThat(^() {
        GooglePlace *place = [GooglePlace createWithPlaceId:_placeIdVeeraswamyLondon location:[CLLocation new] cuisineRelevance:34];
        [_service getRestaurantForPlace:place currentLocation:_norwich];
    }, throwsExceptionOfType([SearchException class]));
}

- (void)test_getRestaurantForPlace_ShouldReturnRestaurantAtPlace {
    GooglePlace *place = [GooglePlace createWithPlaceId:_placeIdVeeraswamyLondon location:_london cuisineRelevance:34];

    Restaurant *restaurant = [_service getRestaurantForPlace:place currentLocation:_norwich];

    assertThatUnsignedInt(restaurant.name.length, is(greaterThan(@0U)));
    assertThatUnsignedInt(restaurant.vicinity.length, is(greaterThan(@0U)));
    assertThat(restaurant.address, is(equalTo(@"Victory House\n99 Regent Street, London W1B 4EZ")));
    assertThatUnsignedInt([restaurant.addressComponents count], is(greaterThan(@0U)));
    for (NSString *component in restaurant.addressComponents) {
        assertThatUnsignedInt(component.length, is(greaterThan(@0U)));
    }
    assertThatUnsignedInt(restaurant.openingStatus.length, is(greaterThan(@0U)));
    assertThatUnsignedInt(restaurant.openingHoursToday.length, is(greaterThan(@0U)));
    assertThatUnsignedInt(restaurant.openingHours.count, is(greaterThan(@0U)));
    assertThat(restaurant.phoneNumber, is(equalTo(@"020 7734 1401")));
    assertThat(restaurant.urlForDisplaying, is(equalTo(@"veeraswamy.com")));
    assertThat(restaurant.url, is(equalTo(@"http://www.veeraswamy.com/")));
    assertThat(restaurant.openingHoursToday, containsString(@"pm"));
    assertThat(restaurant.placeId, is(equalTo(place.placeId)));
    assertThat(restaurant.location, is(notNilValue()));
    assertThatUnsignedInt(restaurant.priceLevel, is(greaterThan(@(0))));
    assertThatDouble(restaurant.cuisineRelevance, is(equalTo(@(34))));
    assertThatDouble(restaurant.distance, is(greaterThan(@(0))));
    assertThatUnsignedInt([restaurant.photos count], is(greaterThan(@1U)));  // there should be more than 1 photo to have a meaningful test here
    for (id <IPhoto> photo in restaurant.photos) {
        NSArray *photos = [[photo image] toArray]; // force loading by enumerating image-Signal
        assertThatUnsignedInt(photos.count, is(equalTo(@1)));
    }
    assertThatBool(((id <IPhoto>) restaurant.photos[0]).isEagerlyLoaded, is(equalTo(@YES)));
    assertThatBool(((id <IPhoto>) restaurant.photos[1]).isEagerlyLoaded, is(equalTo(@NO)));

    RestaurantRating *rating = restaurant.rating;
    assertThat(rating, is(notNilValue()));
    assertThatDouble(rating.rating, is(greaterThan(@(0))));
    assertThatInt(rating.reviews.count, is(greaterThan(@(0))));
    for (RestaurantReview *review in rating.reviews) {
        assertThatInt(review.text.length, is(greaterThan(@(0))));
        assertThatInt(review.author.length, is(greaterThan(@(0))));
        assertThat(review.date, is(notNilValue()));
        assertThatDouble(review.rating, is(greaterThan(@(0))));
    }
}

- (void)test_getRestaurantForPlace_ShouldReturnCorrectDistanceFromCurrentLocation {
    GooglePlace *place = [GooglePlace createWithPlaceId:_placeIdVeeraswamyLondon location:_london cuisineRelevance:34];

    Restaurant *restaurantAsSeenInNorwich = [_service getRestaurantForPlace:place currentLocation:_norwich];
    Restaurant *restaurantAsSeenInLondon = [_service getRestaurantForPlace:place currentLocation:_london];

    assertThatDouble(restaurantAsSeenInNorwich.distance, is(greaterThan(@(restaurantAsSeenInLondon.distance))));
}

- (void)test_getRestaurantForPlace_ShouldSetNoInfoAboutOpeningHours_WhenNoOpeningHoursAvailable {
    GooglePlace *place = [GooglePlace createWithPlaceId:_placeIdEveningRiverCruiseYork location:[CLLocation new] cuisineRelevance:34];

    Restaurant *restaurant = [_service getRestaurantForPlace:place currentLocation:_norwich];
    assertThat(restaurant.openingHoursToday, is(equalTo(@"")));
    assertThat(restaurant.openingStatus, is(equalTo(@"")));
}

@end
