//
// Created by Jorg on 20/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OpeningHour : NSObject<NSCoding>
@property (readonly, nonatomic) NSString* day;
@property (readonly, nonatomic) NSString* hours;
@property (readonly, nonatomic) BOOL isToday;

- (id)initWithDay:(NSString *)day hours:(NSString *)hours isToday:(BOOL)isToday;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToHour:(OpeningHour *)hour;

- (NSUInteger)hash;

+(instancetype)create:(NSString*)day hours:(NSString*)hours isToday:(BOOL)isToday;
@end