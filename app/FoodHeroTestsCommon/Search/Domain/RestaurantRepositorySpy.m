//
// Created by Jorg on 19/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantRepositorySpy.h"


@implementation RestaurantRepositorySpy {

}
- (RACSignal *)getPlacesBy:(CuisineAndOccasion *)cuisine {
    _getPlacesByCuisineParameter = cuisine;
    return [RACSignal empty];
}

- (Restaurant *)getRestaurantFromPlace:(GooglePlace *)place {
    return nil;
}

- (double)getMaxDistanceOfPlaces:(CLLocation *)currLocation {
    return 0;
}

@end