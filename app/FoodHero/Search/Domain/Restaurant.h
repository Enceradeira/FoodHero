//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GooglePlace.h"
#import "Place.h"


@interface Restaurant : Place
@property(nonatomic, readonly) NSString *vicinity;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *address;
@property(nonatomic, readonly) NSString *openingStatus;
@property(nonatomic, readonly) NSString *openingHours;
@property(nonatomic, readonly) NSString *phoneNumber;
@property(nonatomic, readonly) NSString *url;
@property(nonatomic, readonly) NSArray *types;

+ (Restaurant *)createWithName:(NSString *)name
                      vicinity:(NSString *)vicinity
                       address:(NSString *)address
                 openingStatus:(NSString *)openingStatus
                  openingHours:(NSString *)openingHours
                   phoneNumber:(NSString *)phoneNumber
                           url:(NSString *)url
                         types:(NSArray *)types
                       placeId:(NSString *)placeId
                      location:(CLLocation *)location
                    priceLevel:(NSUInteger)priceLevel
              cuisineRelevance:(double)cuisineRelevance;
@end