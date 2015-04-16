//
// Created by Jorg on 16/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEnvironment.h"


@interface GoogleOpeningHours : NSObject
+ (instancetype)createWithPeriods:(NSArray *)openingPeriods environment:(id <IEnvironment>)environment;

- (id)initWithPeriods:(NSArray *)openingPeriods environment:(id <IEnvironment>)environment;

- (NSString *)descriptionForDate:(NSDate *)date;

- (NSArray *)descriptionForWeek;
@end