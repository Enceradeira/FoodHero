//
// Created by Jorg on 16/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "GoogleOpeningHours.h"
#import "OpeningHour.h"
#import "TyphoonComponents.h"
#import "IEnvironment.h"


@implementation GoogleOpeningHours {

    NSArray *_openingPeriods;
    id <IEnvironment> _environment;
}
+ (instancetype)createWithPeriods:(NSArray *)openingPeriods environment:(id <IEnvironment>)environment {
    return [[GoogleOpeningHours alloc] initWithPeriods:openingPeriods environment:environment];
}

- (id)initWithPeriods:(NSArray *)openingPeriods environment:(id <IEnvironment>)environment {
    self = [super init];
    if (self) {
        _openingPeriods = openingPeriods;
        _environment = environment;
    }
    return self;
}

- (NSString *)descriptionForDate:(NSDate *)date {
    NSInteger weekday = [self getDayInWeek:date];

    return [self buildDescriptionForWeekday:weekday separator:@"\n"];
}

- (NSInteger)getDayInWeek:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [comps weekday] - 1;
    return weekday;
}

- (NSString *)buildDescriptionForWeekday:(NSInteger)weekday separator:(NSString *)separator {
    NSArray *openingPeriodOfWeekday = [_openingPeriods linq_where:^(NSDictionary *period) {
        NSDictionary *openInfo = period[@"open"];
        return (BOOL) ([openInfo[@"day"] integerValue] == weekday);
    }];
    NSArray *openingPeriodTodayComponents = [openingPeriodOfWeekday linq_select:^(NSDictionary *period) {
        id open = period[@"open"];
        id close = period[@"close"];
        NSArray *openTime = [self formatTime:open[@"time"]];
        NSArray *closeTime = [self formatTime:close[@"time"]];

        if ([openTime[1] isEqualToString:closeTime[1]]) {
            // postfix is the same ('am' or 'pm')
            return [NSString stringWithFormat:@"%@-%@ %@", openTime[0], closeTime[0], closeTime[1]];
        }
        else {
            return [NSString stringWithFormat:@"%@ %@-%@ %@", openTime[0], openTime[1], closeTime[0], closeTime[1]];
        }
    }];
    NSString *openingPeriodTodayString = [openingPeriodTodayComponents componentsJoinedByString:separator];
    return openingPeriodTodayString;
}

- (NSArray *)formatTime:(NSString *)time {
    NSInteger hours = [[time substringToIndex:2] integerValue];
    NSString *minutes = [time substringFromIndex:2];
    NSInteger hoursAndMinutes = [time integerValue];
    NSString *postfix;
    if (hoursAndMinutes < 100) {
        postfix = @"am";
        hours += 12;
    }
    else if (hoursAndMinutes < 1200) {
        postfix = @"am";
    }
    else if (hoursAndMinutes < 1300) {
        postfix = @"pm";
    }
    else if (hoursAndMinutes == 2400) {
        postfix = @"am";
        hours = 12;
    }
    else {
        postfix = @"pm";
        hours -= 12;
    }

    return @[[NSString stringWithFormat:@"%li:%@", (long)hours, minutes], postfix];
}

- (NSArray *)descriptionForWeek {
    NSInteger currDayInWeek = [self getDayInWeek:[_environment now]];

    NSMutableArray *description = [NSMutableArray new];
    NSArray *weekdays = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];

    for (NSUInteger sunToSat = 0; sunToSat < 7; sunToSat++) {
        NSUInteger monToSun = sunToSat == 6 ? 0 : sunToSat + 1;

        NSString *desc = [self buildDescriptionForWeekday:monToSun separator:@", "];
        NSString *openingHours = [desc isEqualToString:@""] ? @"closed" : desc;
        [description addObject:[OpeningHour create:weekdays[monToSun] hours:openingHours isToday:currDayInWeek == monToSun]];
    }
    return description;
}
@end