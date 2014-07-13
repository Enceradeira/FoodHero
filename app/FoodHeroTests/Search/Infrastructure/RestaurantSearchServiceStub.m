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

- (void)injectFindResult:(Restaurant *)restaurant {
    _searchResult = restaurant;
}

- (NSArray *)find:(RestaurantSearchParams *)parameter {
    NSMutableArray *result = [NSMutableArray new];
    if (_searchResult != nil) {
        [result addObject:_searchResult];
    }
    else {
        [result addObject:[Restaurant createWithName:@"King's Head" withVicinity:@"Norwich" withTypes:nil]];
    }
    return result;
}


@end