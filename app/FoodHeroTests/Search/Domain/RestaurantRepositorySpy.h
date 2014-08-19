//
// Created by Jorg on 19/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRestaurantRepository.h"


@interface RestaurantRepositorySpy : NSObject<IRestaurantRepository>
@property (nonatomic, readonly) NSString* getPlacesByCuisineOrderedByDistanceParameter;
@end