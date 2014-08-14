//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Place : NSObject
@property(nonatomic, readonly) NSString *placeId;
@property(nonatomic, readonly) CLLocation *location;

- (instancetype)initWithPlaceId:(NSString *)placeId location:(CLLocation *)location;

+ (instancetype)createWithPlaceId:(NSString *)placeId location:(CLLocation *)location;

@end