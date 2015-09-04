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
    ResolvedSearchLocation *_norwich;
    ResolvedSearchLocation *_london;
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
    CLLocation *norwichLocation = [[CLLocation alloc] initWithLatitude:52.631944 longitude:1.298889];
    _norwich = [[ResolvedSearchLocation alloc] initWithLocation:norwichLocation description:@"Norwich"];
    CLLocation *londonLocation = [[CLLocation alloc] initWithLatitude:51.5072 longitude:-0.1275];
    _london = [[ResolvedSearchLocation alloc] initWithLocation:londonLocation description:@""];

    _parameter = [RestaurantSearchParams new];
    _parameter.coordinate = _norwich.location.coordinate;
    _parameter.radius = 10000;
    _parameter.cuisineAndOccasion = [[CuisineAndOccasion alloc] initWithOccasion:[Occasions dinner] cuisine:@"Indian" location:nil];

    _assembly = [TyphoonComponents getAssembly];
    _service = [[GoogleRestaurantSearch alloc] initWithEnvironment:[_assembly environment] onlyOpenNow:false /*otherwise tests become unstable*/ ];
}

- (GooglePlace *)findPlaceById:(NSString *)idLibraryGrillNorwich result:(NSArray *)result {
    return [[result linq_where:^(GooglePlace *place) {
        return [place.placeId isEqualToString:idLibraryGrillNorwich];
    }] linq_firstOrNil];
}

- (void)test_getRestaurantForPlace_ShouldThrowException_WhenThereIsANetworkingError {
    _service.baseAddress = @"https://jennius.com"; // this should throw a networking error since no search is available at this address
    _service.timeout = 0.1;

    assertThat(^() {
        GooglePlace *place = [GooglePlace createWithPlaceId:_placeIdVeeraswamyLondon location:[CLLocation new] cuisineRelevance:34];
        [_service getRestaurantForPlace:place searchLocation:_norwich];
    }, throwsExceptionOfType([SearchException class]));
}

- (void)test_getRestaurantForPlace_ShouldReturnRestaurantAtPlace {
    GooglePlace *place = [GooglePlace createWithPlaceId:_placeIdVeeraswamyLondon location:_london.location cuisineRelevance:34];

    Restaurant *restaurant = [_service getRestaurantForPlace:place searchLocation:_norwich];

    assertThatUnsignedInt(restaurant.name.length, is(greaterThan(@0U)));
    assertThat(restaurant.nameUnique, is(equalTo(restaurant.name)));
    assertThatUnsignedInt(restaurant.vicinity.length, is(greaterThan(@0U)));
    assertThatUnsignedInt(restaurant.address.length,  is(greaterThan(@0U)));
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
    assertThatDouble(restaurant.distance.distanceFromSearchLocation, is(greaterThan(@(0))));
    assertThat(restaurant.distance.searchLocation, is(equalTo(_norwich.location)));
    assertThat(restaurant.distance.searchLocationDescription, is(equalTo(_norwich.locationDescription)));
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
    GooglePlace *place = [GooglePlace createWithPlaceId:_placeIdVeeraswamyLondon location:_london.location cuisineRelevance:34];

    Restaurant *restaurantAsSeenInNorwich = [_service getRestaurantForPlace:place searchLocation:_norwich];
    Restaurant *restaurantAsSeenInLondon = [_service getRestaurantForPlace:place searchLocation:_london];

    assertThatDouble(restaurantAsSeenInNorwich.distance.distanceFromSearchLocation, is(greaterThan(@(restaurantAsSeenInLondon.distance.distanceFromSearchLocation))));
}

- (void)test_getRestaurantForPlace_ShouldSetNoInfoAboutOpeningHours_WhenNoOpeningHoursAvailable {
    GooglePlace *place = [GooglePlace createWithPlaceId:_placeIdEveningRiverCruiseYork location:[CLLocation new] cuisineRelevance:34];

    Restaurant *restaurant = [_service getRestaurantForPlace:place searchLocation:_norwich];
    assertThat(restaurant.openingHoursToday, is(equalTo(@"")));
    assertThat(restaurant.openingStatus, is(equalTo(@"")));
}

@end
