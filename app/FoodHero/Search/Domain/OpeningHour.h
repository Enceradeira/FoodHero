//
// Created by Jorg on 20/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OpeningHour : NSObject
@property (readonly, nonatomic) NSString* day;
@property (readonly, nonatomic) NSString* hours;
@property (readonly, nonatomic) BOOL isToday;
+(instancetype)create:(NSString*)day hours:(NSString*)hours isToday:(BOOL)isToday;
@end