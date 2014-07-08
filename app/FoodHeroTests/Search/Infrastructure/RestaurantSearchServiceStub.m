//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantSearchServiceStub.h"


@implementation RestaurantSearchServiceStub {
    Restaurant *_searchResult;
}

- (id)init {
    self = [super init];
    if (self != nil) {

    }
    return self;
}

- (void)injectSearchResult:(Restaurant *)restaurant {
    _searchResult = restaurant;
}

- (Restaurant *)findBest {
    return _searchResult != nil ? _searchResult : [Restaurant createWithName:@"King's Head" place:@"Norwich"];
}

@end