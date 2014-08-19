//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantRepositoryTests.h"
#import "Place.h"
#import "RACSignal.h"
#import "RestaurantRepository.h"
#import "DesignByContractException.h"


@implementation RestaurantRepositoryTests {

}

- (NSArray *)getPlacesByCuisineOrderedByDistance:(NSString *)cuisine {
    __block NSMutableArray *places = [NSMutableArray new];
    RACSignal *signal = [self.repository getPlacesByCuisineOrderedByDistance:cuisine];
    [signal subscribeNext:^(Place *r) {
        [places addObject:r];
    }];
    return places;
}

-(RestaurantRepository *)repository{
    @throw [DesignByContractException createWithReason:@"methode must be override by subclass"];
}

@end