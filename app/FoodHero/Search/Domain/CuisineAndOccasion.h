//
// Created by Jorg on 17/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface CuisineAndOccasion : NSObject
@property(readonly, nonatomic) NSString *occasion;
@property(readonly, nonatomic) NSString *cuisine;
@property(readonly, nonatomic) CLLocation *location;

- (instancetype)initWithOccasion:(NSString *)occasion cuisine:(NSString *)cuisine location:(CLLocation *)location;
@end