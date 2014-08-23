//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface GooglePlace : NSObject
@property(nonatomic, readonly) NSString *placeId;
@property(nonatomic, readonly) CLLocation *location;
@property(nonatomic, readonly) NSUInteger cuisineRelevance;

- (instancetype)initWithPlaceId:(NSString *)placeId location:(CLLocation *)location cuisineRelevance:(NSUInteger)cuisineRelevance;

+ (instancetype)createWithPlaceId:(NSString *)placeId location:(CLLocation *)location cuisineRelevance:(NSUInteger)cuisineRelevance;

@end