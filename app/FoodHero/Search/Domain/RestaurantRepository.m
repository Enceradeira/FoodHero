//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRepository.h"
#import "RadiusCalculator.h"
#import "SearchParameter.h"
#import "GoogleRestaurantSearch.h"
#import "DesignByContractException.h"

@implementation RestaurantRepository {
    id <RestaurantSearchService> _searchService;
    LocationService *_locationService;
    CLLocation *_locationAtMomentOfCaching;
    NSString *_cuisineAtMomentOfCaching;
    NSArray *_placesCached;
}
- (instancetype)initWithSearchService:(id <RestaurantSearchService>)searchService locationService:(LocationService *)locationService {
    self = [super init];
    if (self != nil) {
        _searchService = searchService;
        _locationService = locationService;
    }
    return self;
}

- (RACSignal *)getPlacesByCuisineOrderedByDistance:(NSString *)cuisine {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        RACSerialDisposable *serialDisposable = [RACSerialDisposable new];

        RACDisposable *sourceDisposable = [[_locationService currentLocation]
                subscribeNext:^(CLLocation *currentLocation) {

                    BOOL isCuisineStillTheSame = [cuisine isEqualToString:_cuisineAtMomentOfCaching];
                    BOOL isLocationStillTheSame = [currentLocation distanceFromLocation:_locationAtMomentOfCaching] < 100;
                    if (_placesCached == nil || !isCuisineStillTheSame || !isLocationStillTheSame) {
                        _locationAtMomentOfCaching = currentLocation;
                        _cuisineAtMomentOfCaching = cuisine;

                        // dynamically adjust radius in order to get as specific results as possible

                        NSArray *places = [self fetchPlaces:cuisine currentLocation:currentLocation];
                        _placesCached = [places sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                            CLLocationDistance distanceA = [[((GooglePlace *) a) location] distanceFromLocation:currentLocation];
                            CLLocationDistance distanceB = [[((GooglePlace *) b) location] distanceFromLocation:currentLocation];

                            if (distanceA < distanceB) {
                                return (NSComparisonResult) NSOrderedAscending;
                            }
                            else if (distanceA > distanceB) {
                                return (NSComparisonResult) NSOrderedDescending;
                            }
                            return (NSComparisonResult) NSOrderedSame;

                        }];
                    }
                    for (Place *place in _placesCached) {
                        [subscriber sendNext:place];
                    }
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                }   completed:^{
                    [subscriber sendCompleted];
                }];

        serialDisposable.disposable = sourceDisposable;
        return serialDisposable;
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

    // Fetch per price Levels
    NSMutableArray *places = [NSMutableArray new];
    for (NSUInteger priceLevel = GOOGLE_PRICE_LEVEL_MIN; priceLevel <= GOOGLE_PRICE_LEVEL_MAX; priceLevel++) {
        RestaurantSearchParams *parameter = [RestaurantSearchParams new];
        parameter.coordinate = currentLocation.coordinate;
        parameter.radius = optimalRadius;
        parameter.cuisine = cuisine;
        parameter.minPriceLevel = priceLevel;
        parameter.maxPriceLevel = priceLevel;
        [places addObjectsFromArray:
                [[_searchService findPlaces:parameter] linq_select:^(GooglePlace *p) {
                    return [Place create:p.placeId location:p.location priceLevel:priceLevel];
                }]];
    }

    if (places.count < placesOfAllPriceLevels.count) {
        @throw [DesignByContractException createWithReason:[
                NSString stringWithFormat:@"number of places (%u) per priceLevel were fewer than over all pricelevels (%u)", places.count, placesOfAllPriceLevels.count]];
    }


    return places;
}

- (Restaurant *)getRestaurantFromPlace:(Place *)place {
    return [_searchService getRestaurantForPlace:place];
}
@end