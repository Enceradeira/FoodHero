//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRepository.h"
#import "RadiusCalculator.h"
#import "SearchProfil.h"
#import "GoogleRestaurantSearch.h"

@implementation RestaurantRepository {
    id <RestaurantSearchService> _searchService;
    LocationService *_locationService;
    CLLocation *_locationAtMomentOfCaching;
    NSString *_cuisineAtMomentOfCaching;
    NSArray *_placesCached;
    NSMutableDictionary *_restaurantsCached;
}
- (instancetype)initWithSearchService:(id <RestaurantSearchService>)searchService locationService:(LocationService *)locationService {
    self = [super init];
    if (self != nil) {
        _searchService = searchService;
        _locationService = locationService;
        _restaurantsCached = [NSMutableDictionary new];
    }
    return self;
}

- (RACSignal *)getPlacesByCuisine:(NSString *)cuisine {
    return [[[_locationService currentLocation] take:1] map:^(CLLocation *currentLocation) {
        BOOL isCuisineStillTheSame = [cuisine isEqualToString:_cuisineAtMomentOfCaching];
        BOOL isLocationStillTheSame = [currentLocation distanceFromLocation:_locationAtMomentOfCaching] < 100;
        if (_placesCached == nil || !isCuisineStillTheSame || !isLocationStillTheSame) {
            _locationAtMomentOfCaching = currentLocation;
            _cuisineAtMomentOfCaching = cuisine;
            _placesCached = [self fetchPlaces:cuisine currentLocation:currentLocation];
        }
        // yields all places as first element in sequence
        return _placesCached;
    }];
}

- (NSArray *)fetchPlaces:(NSString *)cuisine currentLocation:(CLLocation *)currentLocation {
    // Determine optimal Radius by fetching over all price-levels to ensure results specific for cuisine
    __block double optimalRadius = GOOGLE_MAX_SEARCH_RADIUS;
    NSArray *placesOfAllPriceLevels = [RadiusCalculator doUntilRightNrOfElementsReturned:^(double radius) {
        RestaurantSearchParams *parameter = [RestaurantSearchParams new];
        parameter.coordinate = currentLocation.coordinate;
        parameter.radius = radius;
        parameter.cuisine = cuisine;
        parameter.minPriceLevel = GOOGLE_PRICE_LEVEL_MIN;
        parameter.maxPriceLevel = GOOGLE_PRICE_LEVEL_MAX;
        optimalRadius = radius;
        return [_searchService findPlaces:parameter];
    }];

   // Fetch per price Levels 1-4 (0 will be reconstructed below)
    NSMutableArray *places = [NSMutableArray new];
    for (NSUInteger priceLevel = GOOGLE_PRICE_LEVEL_MIN + 1; priceLevel <= GOOGLE_PRICE_LEVEL_MAX; priceLevel++) {
        RestaurantSearchParams *parameter = [RestaurantSearchParams new];
        parameter.coordinate = currentLocation.coordinate;
        parameter.radius = optimalRadius;
        parameter.cuisine = cuisine;
        parameter.minPriceLevel = priceLevel;
        parameter.maxPriceLevel = priceLevel;
        NSArray *placesOfLevel = [[_searchService findPlaces:parameter] linq_select:^(GooglePlace *p) {
            return [Place create:p.placeId location:p.location priceLevel:priceLevel];
        }];

        NSArray *specificEnoughPlaces = [placesOfLevel linq_where:^(Place *place) {
            return [placesOfAllPriceLevels linq_any:^(Place *specificPlace) {
                return [place.placeId isEqualToString:specificPlace.placeId];
            }];
        }];

        [places addObjectsFromArray:specificEnoughPlaces];
    }

    // all that were not level 1-4 are level 0 (we get wrong results if we query level 0 directly??)
    NSArray *placesOfLevel0 = [[placesOfAllPriceLevels linq_where:^(Place *p1) {
        return (BOOL) ![places linq_any:^(Place *p2) {
            return [p1.placeId isEqualToString:p2.placeId];
        }];
    }] linq_select:^(GooglePlace *p) {
        return [Place create:p.placeId location:p.location priceLevel:GOOGLE_PRICE_LEVEL_MIN];
    }];

    [places addObjectsFromArray:placesOfLevel0];
    return places;
}

- (Restaurant *)getRestaurantFromPlace:(Place *)place {
    Restaurant *restaurant = _restaurantsCached[place.placeId];
    if (restaurant == nil) {
        restaurant = [_searchService getRestaurantForPlace:place];
        _restaurantsCached[place.placeId] = restaurant;
    }
    return restaurant;
}
@end