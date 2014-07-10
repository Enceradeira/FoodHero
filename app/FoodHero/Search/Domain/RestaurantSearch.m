//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "RestaurantSearch.h"

@implementation RestaurantSearch {

    id <RestaurantSearchService> _searchService;
    id <LocationService> _locationService;
}

- (id)initWithSearchService:(id <RestaurantSearchService>)searchService withLocationService:(id <LocationService>)locationService {
    self = [super init];
    if (self != nil) {
        _searchService = searchService;
        _locationService = locationService;
    }
    return self;
}

- (RACSignal *)findBest {
    RACSignal *racSignal = [_locationService currentLocation];
    return [racSignal map:^(id value){
        CLLocationCoordinate2D coordinate;
        coordinate.longitude, coordinate.latitude = 0;
        [((NSValue *) value) getValue:&coordinate];

        RestaurantSearchParams *parameter = [RestaurantSearchParams new];
        parameter.location = coordinate;
        parameter.radius = 2000;
        NSArray *restaurants = [_searchService find:parameter];
        if (restaurants.count > 0) {
            return (Restaurant *) restaurants[0];
        }
        else {
            return [Restaurant createWithName:@"Marsblaster" withVicinity:@"on the Moon" withTypes:[NSArray new]];
        }
    }];
}
@end