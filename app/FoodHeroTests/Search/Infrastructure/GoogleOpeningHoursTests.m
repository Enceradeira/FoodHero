//
//  GoogleOpeningHoursTests.m
//  FoodHero
//
//  Created by Jorg on 16/10/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest.h>
#import "GoogleOpeningHours.h"

@interface GoogleOpeningHoursTests : XCTestCase

@end

@implementation GoogleOpeningHoursTests {
    NSArray *_periods;
}

- (void)setUp {
    [super setUp];

    _periods = @[
            // Sunday (day 0)
            [self openDay:@"0" openTime:@"0000" closeDay:@"0" closeTime:@"1200"],
            [self openDay:@"0" openTime:@"1315" closeDay:@"0" closeTime:@"2400"],
            // Monday
            [self openDay:@"1" openTime:@"0730" closeDay:@"1" closeTime:@"1200"],
            [self openDay:@"1" openTime:@"1300" closeDay:@"1" closeTime:@"1700"],
            // Tuesday
            [self openDay:@"1" openTime:@"2330" closeDay:@"2" closeTime:@"0200"],
            [self openDay:@"2" openTime:@"0730" closeDay:@"2" closeTime:@"1300"],
            [self openDay:@"2" openTime:@"1845" closeDay:@"3" closeTime:@"0100"],
            // Wednesday
            [self openDay:@"3" openTime:@"0730" closeDay:@"3" closeTime:@"1200"],
            [self openDay:@"3" openTime:@"1300" closeDay:@"3" closeTime:@"1800"],
            [self openDay:@"3" openTime:@"1815" closeDay:@"3" closeTime:@"2330"],
            // Friday
            [self openDay:@"5" openTime:@"0730" closeDay:@"5" closeTime:@"2300"],
            // Saturday
            [self openDay:@"6" openTime:@"0730" closeDay:@"6" closeTime:@"1130"],
    ];
}

- (NSDate *)gmtDateFrom:(int)year month:(int)month day:(int)day {
    NSDateComponents *mondayComponents = [[NSDateComponents alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [mondayComponents setTimeZone:timeZone];
    [mondayComponents setDay:day];
    [mondayComponents setMonth:month];
    [mondayComponents setYear:year];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *monday = [calendar dateFromComponents:mondayComponents];
    return monday;
}

- (NSDictionary *)openDay:(NSString *)openDay openTime:(NSString *)openTime closeDay:(NSString *)closeDay closeTime:(NSString *)closeTime {
    return @{
            @"open" : [self day:openDay time:openTime],
            @"close" : [self day:closeDay time:closeTime]};
}

- (NSDictionary *)day:(NSString *)day time:(NSString *)time {
    return @{@"day" : day, @"time" : time};
}

- (NSDate *)getDayOfWeek:(int)dayOfWeek {
    return [self gmtDateFrom:2014 month:10 day:12 + dayOfWeek];  // 12th is sunday which is day 0 in week
}

- (NSString *)descriptionForDate:(NSDate *)dayOfWeek {
    return [[GoogleOpeningHours createWithPeriods:_periods] descriptionForDate:dayOfWeek];
}

- (void)test_descriptionForDate_ShouldReturnFormattedDescriptionOfOpeningHours_WhenOnePeriod {

    NSString *desc = [self descriptionForDate:[self getDayOfWeek:5]];

    assertThat(desc, is(equalTo(@"7:30 am-11:00 pm")));
}

- (void)test_descriptionForDate_ShouldReturnFormattedDescriptionOfOpeningHours_WhenTwoPeriods {

    NSString *desc = [self descriptionForDate:[self getDayOfWeek:0]];

    assertThat(desc, is(equalTo(@"12:00 am-12:00 pm\n1:15 pm-12:00 am")));

}

- (void)test_descriptionForDate_ShouldReturnFormattedDescriptionOfOpeningHours_WhenSaturday {
    NSString *desc = [self descriptionForDate:[self getDayOfWeek:6]];

    assertThat(desc, is(equalTo(@"7:30-11:30 am")));
}

- (void)test_descriptionForDate_ShouldReturnFormattedDescriptionOfOpeningHours_WhenSunday {
    NSString *desc = [self descriptionForDate:[self getDayOfWeek:0]];

    assertThat(desc, is(equalTo(@"12:00 am-12:00 pm\n1:15 pm-12:00 am")));
}

- (void)test_descriptionForDate_ShouldReturnFormattedDescriptionOfOpeningHours_WhenNoPeriod {
    NSString *desc = [self descriptionForDate:[self getDayOfWeek:4]];

    assertThat(desc, is(equalTo(@"")));
}

- (void)test_descriptionForDate_ShouldReturnFormattedDescriptionOfOpeningHours_WhenPeriodEndsInOtherDay {
    NSString *desc = [self descriptionForDate:[self getDayOfWeek:2]];

    assertThat(desc, is(equalTo(@"7:30 am-1:00 pm\n6:45 pm-1:00 am")));
}

- (void)test_descriptionForDate_ShouldNotShowOpeningHours_WhenItClosesAtEarliestMomentOfDay {
    _periods = @[
            [self openDay:@"3" openTime:@"1200" closeDay:@"4" closeTime:@"0000"],
            [self openDay:@"4" openTime:@"1200" closeDay:@"5" closeTime:@"0100"]
    ];

    NSString *desc = [self descriptionForDate:[self getDayOfWeek:4]];
    assertThat(desc, is(equalTo(@"12:00 pm-1:00 am")));
}

- (void)test_descriptionForDate_ShouldNotShowOpeningHours_WhenItOnlyClosesAtDay {
    _periods = @[
            [self openDay:@"3" openTime:@"1200" closeDay:@"4" closeTime:@"0200"],
            [self openDay:@"4" openTime:@"1200" closeDay:@"5" closeTime:@"0100"]
    ];

    NSString *desc = [self descriptionForDate:[self getDayOfWeek:4]];
    assertThat(desc, is(equalTo(@"12:00 pm-1:00 am")));
}

@end
