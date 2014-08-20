//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantSearchService.h"

// see https://developers.google.com/places/documentation/search#RadarSearchRequests
extern const NSUInteger GOOGLE_MAX_SEARCH_RESULTS;
extern const NSUInteger GOOGLE_MAX_SEARCH_RADIUS;

@interface GoogleRestaurantSearch : NSObject <RestaurantSearchService>

@end