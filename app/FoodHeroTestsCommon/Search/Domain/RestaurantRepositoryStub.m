//
// Created by Jorg on 19/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//


#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRepositoryStub.h"
#import "FoodHero-Swift.h"


@implementation RestaurantRepositoryStub {
    NSArray *_restaurants;
    SearchException *_exceptionForGetRestaurantFromPlace;
    SearchException *_exceptionForGetPlacesBy;
}
- (id)init {
    self = [super init];
    if (self) {
        _restaurants = [NSArray new];
    }
    return self;
}


- (void)injectRestaurants:(NSArray *)restaurants {
    _restaurants = restaurants;
}

- (NSArray *)getPlacesBy:(CuisineAndOccasion *)cuisine {
    if (_exceptionForGetPlacesBy != nil) {
        @throw _exceptionForGetPlacesBy;
    }

    return _restaurants;
}

- (Restaurant *)getRestaurantFromPlace:(Place *)place searchLocation:(ResolvedSearchLocation *)currentLocation {
    if (_exceptionForGetRestaurantFromPlace != nil) {
        @throw _exceptionForGetRestaurantFromPlace;
    }

    Restaurant *r = [[_restaurants linq_where:^(Restaurant *r) {
        return [r.placeId isEqualToString:place.placeId];
    }] linq_firstOrNil];

    assert(r != nil);

    double distanceFromSearchLocation = r.distance.distanceFromSearchLocation;
    RestaurantDistance *distance = [[RestaurantDistance alloc] initWithSearchLocation:currentLocation.location
                                                            searchLocationDescription:currentLocation.locationDescription
                                                           distanceFromSearchLocation:distanceFromSearchLocation];

    return [Restaurant createWithName:r.name
                           nameUnique:r.nameUnique
                             vicinity:r.vicinity
                              address:r.address
                    addressComponents:r.addressComponents
                        openingStatus:r.openingStatus
                    openingHoursToday:r.openingHoursToday
                         openingHours:r.openingHours
                          phoneNumber:r.phoneNumber
                                  url:r.url
                     urlForDisplaying:r.urlForDisplaying
                                types:r.types
                              placeId:r.placeId
                             location:r.location
                             distance:distance
                           priceLevel:r.priceLevel
                     cuisineRelevance:r.cuisineRelevance
                               rating:r.rating
                               photos:r.photos];
}

- (double)getMaxDistanceOfPlaces:(CLLocation *)currLocation {
    NSArray *distances = [_restaurants linq_select:^(Place *p) {
        CLLocation *placeLocation = p.location;
        return @([currLocation distanceFromLocation:placeLocation]);
    }];
    NSNumber *result = [[distances linq_sort] linq_lastOrNil];

    return result == nil ? 0 : [result doubleValue];
}

- (BOOL)doRestaurantsHaveDifferentPriceLevels {
    return NO;
}

- (void)simulateNoRestaurantFound:(BOOL)simulateNotRestaurantFound {

}

- (void)simulateNetworkError:(BOOL)simulationEnabled {

}

- (void)simulateSlowResponse:(BOOL)enabled {

}

- (void)injectExceptionForGetRestaurantFromPlace:(SearchException *)exception {
    _exceptionForGetRestaurantFromPlace = exception;
}

- (void)injectExceptionForGetPlacesBy:(SearchException *)exception {
    _exceptionForGetPlacesBy = exception;
}
@end