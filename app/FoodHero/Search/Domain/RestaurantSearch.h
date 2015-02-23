//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "Restaurant.h"
#import "RestaurantSearchService.h"
#import "LocationService.h"
#import "ConversationSource.h"
#import "IRestaurantRepository.h"
#import "ISchedulerFactory.h"

@class SearchProfile;

@interface RestaurantSearch : NSObject
- (instancetype)initWithRestaurantRepository:(id <IRestaurantRepository>)repository locationService:(LocationService *)locationService schedulerFactory:(id<ISchedulerFactory>) schedulerFactory;

- (RACSignal *)findBestWithSearchProfile:(SearchProfile *)profile excludedPlaces:(NSArray *)excludedPlaceIds;
@end