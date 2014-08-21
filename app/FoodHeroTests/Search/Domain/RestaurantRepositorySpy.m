//
// Created by Jorg on 19/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantRepositorySpy.h"
#import "RACSignal.h"
#import "Restaurant.h"


@implementation RestaurantRepositorySpy {

}
- (RACSignal *)getPlacesByCuisine:(NSString *)cuisine {
    _getPlacesByCuisineParameter = cuisine;
    return [RACSignal empty];
}

- (Restaurant *)getRestaurantFromPlace:(GooglePlace *)place {
    return nil;
}

@end