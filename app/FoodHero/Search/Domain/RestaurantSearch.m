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
    return [_searchService find:NULL][0];
}
@end