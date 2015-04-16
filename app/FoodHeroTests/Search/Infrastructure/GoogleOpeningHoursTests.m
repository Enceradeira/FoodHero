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
#import "OpeningHour.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "EnvironmentStub.h"

@interface GoogleOpeningHoursTests : XCTestCase

@end

@implementation GoogleOpeningHoursTests {
    NSArray *_periods;
    EnvironmentStub *_environment;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _environment = [(id <ApplicationAssembly>) [TyphoonComponents getAssembly] environment];

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
    return [[GoogleOpeningHours createWithPeriods:_periods environment:_environment] descriptionForDate:dayOfWeek];
}

- (void)test_descriptionForWeek_ShouldBeYesForToday_WhenEntryIsToday {
    NSDate *monday = [self getDayOfWeek:1];
    [_environment injectNow:monday];

    NSArray *descriptions = [[GoogleOpeningHours createWithPeriods:_periods environment:_environment] descriptionForWeek];

    for (OpeningHour *openingHour in descriptions) {
        if ([openingHour.day isEqualToString:@"Monday"]) {
            assertThatBool(openingHour.isToday, is(@(YES)));
        }
        else {
            assertThatBool(openingHour.isToday, is(@(NO)));
        }
    }
}

- (void)test_descriptionForWeek_ShouldReturnFormattedDescription {
    NSArray *desc = [[GoogleOpeningHours createWithPeriods:_periods environment:_environment] descriptionForWeek];
    assertThatInt(desc.count, is(equalTo(@(7))));

    assertThat(((OpeningHour *) desc[0]).day, is(equalTo(@"Monday")));
    assertThat(((OpeningHour *) desc[0]).hours, is(equalTo(@"7:30 am-12:00 pm, 1:00-5:00 pm, 11:30 pm-2:00 am")));
    assertThat(((OpeningHour *) desc[1]).day, is(equalTo(@"Tuesday")));
    assertThat(((OpeningHour *) desc[1]).hours, is(equalTo(@"7:30 am-1:00 pm, 6:45 pm-1:00 am")));
    assertThat(((OpeningHour *) desc[2]).day, is(equalTo(@"Wednesday")));
    assertThat(((OpeningHour *) desc[2]).hours, is(equalTo(@"7:30 am-12:00 pm, 1:00-6:00 pm, 6:15-11:30 pm")));
    assertThat(((OpeningHour *) desc[3]).day, is(equalTo(@"Thursday")));
    assertThat(((OpeningHour *) desc[3]).hours, is(equalTo(@"closed")));
    assertThat(((OpeningHour *) desc[4]).day, is(equalTo(@"Friday")));
    assertThat(((OpeningHour *) desc[4]).hours, is(equalTo(@"7:30 am-11:00 pm")));
    assertThat(((OpeningHour *) desc[5]).day, is(equalTo(@"Saturday")));
    assertThat(((OpeningHour *) desc[5]).hours, is(equalTo(@"7:30-11:30 am")));
    assertThat(((OpeningHour *) desc[6]).day, is(equalTo(@"Sunday")));
    assertThat(((OpeningHour *) desc[6]).hours, is(equalTo(@"12:00 am-12:00 pm, 1:15 pm-12:00 am")));
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
