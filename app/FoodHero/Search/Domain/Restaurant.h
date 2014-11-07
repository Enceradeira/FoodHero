//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GooglePlace.h"
#import "Place.h"
#import "RestaurantRating.h"


@interface Restaurant : Place
@property(nonatomic, readonly) NSString *vicinity;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *address;
@property(nonatomic, readonly) NSArray *addressComponents;
@property(nonatomic, readonly) NSString *openingStatus;
@property(nonatomic, readonly) NSString *openingHoursToday;
@property(nonatomic, strong) NSArray *openingHours;
@property(nonatomic, readonly) NSString *phoneNumber;
@property(nonatomic, readonly) NSString *urlForDisplaying;
@property(nonatomic, readonly) NSString *url;
@property(nonatomic, readonly) NSArray *types;
@property(nonatomic, readonly) double distance;
@property(nonatomic, readonly) RestaurantRating *rating;
@property(nonatomic, readonly) NSArray *photos;

+ (Restaurant *)createWithName:(NSString *)name
                      vicinity:(NSString *)vicinity
                       address:(NSString *)address
             addressComponents:(NSArray *)addressComponents
                 openingStatus:(NSString *)openingStatus
             openingHoursToday:(NSString *)openingHoursToday
                  openingHours:(NSArray *)openingHours
                   phoneNumber:(NSString *)phoneNumber
                           url:(NSString *)url
              urlForDisplaying:(NSString *)urlForDisplaying
                         types:(NSArray *)types
                       placeId:(NSString *)placeId
                      location:(CLLocation *)location
                      distance:(double)distance
                    priceLevel:(NSUInteger)priceLevel
              cuisineRelevance:(double)cuisineRelevance
                        rating:(RestaurantRating *)rating
                        photos:(NSArray *)photos;
@end