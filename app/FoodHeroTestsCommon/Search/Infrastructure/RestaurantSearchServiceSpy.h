//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantSearchService.h"


@interface RestaurantSearchServiceSpy : NSObject <RestaurantSearchService>
@property(nonatomic, readonly) RestaurantSearchParams *findPlacesParameter;

- (NSUInteger)nrCallsToGetRestaurantForPlace;
@end