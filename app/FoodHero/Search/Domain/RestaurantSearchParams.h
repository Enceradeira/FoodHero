//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RestaurantSearchParams : NSObject
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic) CLLocationDistance radius;
@property(nonatomic) NSString *cuisine;
@property(nonatomic) NSUInteger minPrice;
@property(nonatomic) NSUInteger maxPrice;
@end