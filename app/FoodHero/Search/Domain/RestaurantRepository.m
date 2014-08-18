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

- (RACSignal *)getPlacesByCuisine:(NSString *)cuisine {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        RACSerialDisposable *serialDisposable = [RACSerialDisposable new];

        RACDisposable *sourceDisposable = [[_locationService currentLocation]
                subscribeNext:^(id value) {
                    NSArray *places;
                    CLLocationCoordinate2D coordinate;
                    [((NSValue *) value) getValue:&coordinate];
                    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];

                    BOOL isCuisineStillTheSame = [cuisine isEqualToString:_cuisineAtMomentOfCaching];
                    BOOL isLocationStillTheSame = [currentLocation distanceFromLocation:_locationAtMomentOfCaching] < 100;
                    if (_placesCached != nil && isCuisineStillTheSame && isLocationStillTheSame) {
                        places = _placesCached;
                    }
                    else {
                        _locationAtMomentOfCaching = currentLocation;
                        _cuisineAtMomentOfCaching = cuisine;

                        // dynamically adjust radius in order to get as specific results as possible

                        places = [RadiusCalculator doUntilRightNrOfElementsReturned:^(double radius) {
                            PriceLevelRange *priceRange = [PriceLevelRange createFullRange];
                            RestaurantSearchParams *parameter = [RestaurantSearchParams new];
                            parameter.coordinate = coordinate;
                            parameter.radius = radius;
                            parameter.cuisine = cuisine;
                            parameter.minPrice = priceRange.min;
                            parameter.maxPrice = priceRange.max;
                            return [_searchService findPlaces:parameter];
                        }];
                        _placesCached = places;
                    }
                    for (Place *place in places) {
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
@end