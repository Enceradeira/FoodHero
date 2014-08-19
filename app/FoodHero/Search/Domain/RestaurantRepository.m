//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantRepository.h"
#import "RadiusCalculator.h"
#import "SearchParameter.h"

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

                        NSArray *places = [RadiusCalculator doUntilRightNrOfElementsReturned:^(double radius) {
                            PriceLevelRange *priceRange = [PriceLevelRange createFullRange];
                            RestaurantSearchParams *parameter = [RestaurantSearchParams new];
                            parameter.coordinate = currentLocation.coordinate;
                            parameter.radius = radius;
                            parameter.cuisine = cuisine;
                            parameter.minPrice = priceRange.min;
                            parameter.maxPrice = priceRange.max;
                            return [_searchService findPlaces:parameter];
                        }];
                        _placesCached = [places sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                            CLLocationDistance distanceA = [[((Place *) a) location] distanceFromLocation:currentLocation];
                            CLLocationDistance distanceB = [[((Place *) b) location] distanceFromLocation:currentLocation];

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

- (Restaurant *)getRestaurantFromPlace:(Place *)place {
    return [_searchService getRestaurantForPlace:place];
}
@end