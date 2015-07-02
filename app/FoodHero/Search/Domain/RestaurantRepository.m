//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRepository.h"
#import "RadiusCalculator.h"
#import "SearchProfile.h"
#import "SearchException.h"
#import "SearchError.h"
#import "GoogleDefinitions.h"
#import "FoodHero-Swift.h"

@implementation RestaurantRepository {
    id <RestaurantSearchService> _searchService;
    CLLocation *_locationAtMomentOfCaching;
    CuisineAndOccasion *_paramsAtMomentOfCaching;
    NSArray *_placesCached;
    NSMutableDictionary *_restaurantsCached;
    BOOL _isSimulatingNoRestaurantFound;
    NSTimeInterval _responseDelay;
}
- (instancetype)initWithSearchService:(id <RestaurantSearchService>)searchService {
    self = [super init];
    if (self != nil) {
        _searchService = searchService;
        _restaurantsCached = [NSMutableDictionary new];
        _isSimulatingNoRestaurantFound = NO;
        _responseDelay = 0;
    }
    return self;
}

- (NSArray *)getPlacesBy:(CuisineAndOccasion *)parameter {

    @synchronized (self) {
        CLLocation *location = parameter.location;

        BOOL isCuisineOrOccasionStillSame =
                [parameter.cuisine isEqualToString:_paramsAtMomentOfCaching.cuisine] &&
                        [parameter.occasion isEqualToString:_paramsAtMomentOfCaching.occasion];

        BOOL isLocationStillTheSame = [location distanceFromLocation:_locationAtMomentOfCaching] < 100;

        if (_isSimulatingNoRestaurantFound) {
            return @[];
        }

        if (_placesCached == nil || !isCuisineOrOccasionStillSame || !isLocationStillTheSame) {
            _locationAtMomentOfCaching = location;
            _paramsAtMomentOfCaching = parameter;

            [self logGAIEventAction:[GAIActions searchParamsOccasion] label:parameter.occasion];
            [self logGAIEventAction:[GAIActions searchParamsCusine] label:parameter.cuisine];

            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
            NSDate *startTime = [NSDate date];
            @try {
                _placesCached = [self fetchPlaces:parameter currentLocation:location];
            }
            @catch (SearchException *exc) {
                _placesCached = nil; // return nil; therefor error will be returned
                @throw;
            }
            @finally {
                NSTimeInterval timeElapsed = [startTime timeIntervalSinceNow];
                [GAIService logTimingWithCategory:[GAICategories externalCallTimings] name:[GAITimingNames restaurantRepository] label:@"" interval:timeElapsed];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
            }
        }
        // sleep a bit to test asynchronous behaviour of the app
        [NSThread sleepForTimeInterval:_responseDelay];
        // yields all places as first element in sequence
        return _placesCached;
    }
}

- (NSArray *)fetchPlaces:(CuisineAndOccasion *)cuisineAndOccasion currentLocation:(CLLocation *)currentLocation {
    // Determine optimal Radius by fetching over all price-levels to ensure results specific for cuisine
    __block double optimalRadius = GOOGLE_MAX_SEARCH_RADIUS;
    NSArray *placesOfAllPriceLevels = [RadiusCalculator doUntilRightNrOfElementsReturned:^(double radius) {
        RestaurantSearchParams *parameter = [RestaurantSearchParams new];
        parameter.coordinate = currentLocation.coordinate;
        parameter.radius = radius;
        parameter.cuisineAndOccasion = cuisineAndOccasion;
        parameter.minPriceLevel = GOOGLE_PRICE_LEVEL_MIN;
        parameter.maxPriceLevel = GOOGLE_PRICE_LEVEL_MAX;
        optimalRadius = radius;
        return [_searchService findPlaces:parameter];
    }];

    GooglePlace *(^getFromPlacesOfAllPriceLevels)(NSString *) = ^(NSString *placeId) {
        return [[placesOfAllPriceLevels linq_where:^(GooglePlace *p2) {
            return [p2.placeId isEqualToString:placeId];
        }] linq_firstOrNil];
    };

    // Fetch per price Levels 1-4 (0 will be reconstructed below)
    NSMutableArray *places = [NSMutableArray new];
    for (NSUInteger priceLevel = GOOGLE_PRICE_LEVEL_MIN + 1; priceLevel <= GOOGLE_PRICE_LEVEL_MAX; priceLevel++) {
        RestaurantSearchParams *parameter = [RestaurantSearchParams new];
        parameter.coordinate = currentLocation.coordinate;
        parameter.radius = optimalRadius;
        parameter.cuisineAndOccasion = cuisineAndOccasion;
        parameter.minPriceLevel = priceLevel;
        parameter.maxPriceLevel = priceLevel;

        NSArray *placesOfLevel = [[[[_searchService findPlaces:parameter]
                linq_select:^(GooglePlace *p) {
                    return getFromPlacesOfAllPriceLevels(p.placeId);
                }]
                linq_where:^(GooglePlace *p) {
                    return (BOOL) ![p isKindOfClass:[NSNull class]];
                }]
                linq_select:^(GooglePlace *p) {
                    return [Place create:p.placeId location:p.location priceLevel:priceLevel cuisineRelevance:p.cuisineRelevance];
                }];


        [places addObjectsFromArray:placesOfLevel];
    }

    // all that were not level 1-4 are level 0 (we get wrong results if we query level 0 directly??)
    NSArray *placesOfLevel0 = [[placesOfAllPriceLevels linq_where:^(Place *p1) {
        return (BOOL) ![places linq_any:^(Place *p2) {
            return [p1.placeId isEqualToString:p2.placeId];
        }];
    }] linq_select:^(GooglePlace *p) {
        return [Place create:p.placeId location:p.location priceLevel:GOOGLE_PRICE_LEVEL_MIN cuisineRelevance:p.cuisineRelevance];
    }];

    [places addObjectsFromArray:placesOfLevel0];
    return places;
}

- (Restaurant *)getRestaurantFromPlace:(Place *)place searchLocation:(CLLocation*)searchLocation {
    @synchronized (self) {
        Restaurant *restaurant = _restaurantsCached[place.placeId];
        if (restaurant == nil) {
            restaurant = [_searchService getRestaurantForPlace:place searchLocation:searchLocation];
            _restaurantsCached[place.placeId] = restaurant;
        }
        return restaurant;
    }
}

- (BOOL)doRestaurantsHaveDifferentPriceLevels {
    @synchronized (self) {
        if (_placesCached == nil || _placesCached.count == 0) {
            return NO;
        }
        NSUInteger firstPriceLevel = ((Place *) _placesCached[0]).priceLevel;
        return [_placesCached linq_any:^(Place *p) {
            return (BOOL) (p.priceLevel != firstPriceLevel);
        }];
    }
}

- (void)simulateNoRestaurantFound:(BOOL)simulateNotRestaurantFound {
    _isSimulatingNoRestaurantFound = simulateNotRestaurantFound;
}

- (void)simulateNetworkError:(BOOL)simulationEnabled {
    _placesCached = nil;
    [_searchService simulateNetworkError:simulationEnabled];
}

- (void)simulateSlowResponse:(BOOL)enabled {
    _responseDelay = enabled ? 5 : 0;
}

- (double)getMaxDistanceOfPlaces:(CLLocation *)currLocation {
    @synchronized (self) {
        if (_placesCached == nil) {
            return 0;
        }
        NSArray *distances = [_placesCached linq_select:^(Place *p) {
            CLLocation *placeLocation = p.location;
            return @([currLocation distanceFromLocation:placeLocation]);
        }];
        NSNumber *result = [[distances linq_sort] linq_lastOrNil];

        return result == nil ? 0 : [result doubleValue];
    }
}

- (void)logGAIEventAction:(NSString *)action label:(NSString *)label {
    [GAIService logEventWithCategory:[GAICategories searchParams] action:action label:label value:0];
};


@end