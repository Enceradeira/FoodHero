//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantSearch.h"
#import "RestaurantSearchService.h"


@implementation RestaurantSearch {

    id <RestaurantSearchService> _searchService;
}

- (id)initWithDependencies:(id <RestaurantSearchService>)searchService {
    self = [super init];
    if (self != nil) {
        _searchService = searchService;
    }
    return self;
}

- (Restaurant *)findBest {
    RestaurantSearchParams *parameter = [RestaurantSearchParams new];
    CLLocationCoordinate2D norwich;
    norwich.latitude =    52.6259;
    norwich.longitude = 1.299484;

    parameter.location = norwich;
    parameter.radius = 2000;
    return [_searchService find:parameter][0];
}
@end