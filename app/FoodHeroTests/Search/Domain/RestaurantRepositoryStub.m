//
// Created by Jorg on 19/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//


#import <ReactiveCocoa.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantRepositoryStub.h"
#import "Restaurant.h"


@implementation RestaurantRepositoryStub {
    NSArray *_restaurants;
}
- (id)init {
    self = [super init];
    if (self) {
        _restaurants = [NSArray new];
    }
    return self;
}


- (void)injectRestaurantsByCuisineOrderedByDistance:(NSArray *)restaurants {
    _restaurants = restaurants;
}


- (RACSignal *)getPlacesByCuisineOrderedByDistance:(NSString *)cuisine {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        for (Restaurant *r in _restaurants) {
            [subscriber sendNext:r];
        }
        [subscriber sendCompleted];
        return nil;
    }];
}

- (Restaurant *)getRestaurantFromPlace:(Place *)place {
    return [[_restaurants linq_where:^(Restaurant *r) {
        return [r.placeId isEqualToString:place.placeId];
    }] linq_firstOrNil];
}

@end