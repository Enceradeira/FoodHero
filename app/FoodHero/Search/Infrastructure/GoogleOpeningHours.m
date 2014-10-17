//
// Created by Jorg on 16/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "GoogleOpeningHours.h"


@implementation GoogleOpeningHours {

    NSArray *_openingPeriods;
}
+ (instancetype)createWithPeriods:(NSArray *)openingPeriods {
    return [[GoogleOpeningHours alloc] initWithPeriods:openingPeriods];
}

- (id)initWithPeriods:(NSArray *)openingPeriods {
    self = [super init];
    if (self) {
        _openingPeriods = openingPeriods;
    }
    return self;
}

- (NSString *)descriptionForDate:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [comps weekday] - 1;

    NSArray *openingPeriodToday = [_openingPeriods linq_where:^(NSDictionary *period) {
        NSDictionary *openInfo = period[@"open"];
        return (BOOL) ([openInfo[@"day"] integerValue] == weekday);
    }];
    NSArray *openingPeriodTodayComponents = [openingPeriodToday linq_select:^(NSDictionary *period) {
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
    NSString *openingPeriodTodayString = [openingPeriodTodayComponents componentsJoinedByString:@"\n"];
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

    return @[[NSString stringWithFormat:@"%i:%@", hours, minutes], postfix];
}
@end