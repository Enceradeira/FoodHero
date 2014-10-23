//
// Created by Jorg on 16/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoogleOpeningHours : NSObject
+ (GoogleOpeningHours *)createWithPeriods:(NSArray *)openingPeriods;

- (id)initWithPeriods:(NSArray *)array;

- (NSString *)descriptionForDate:(NSDate *)date;

- (NSArray *)descriptionForWeek;
@end