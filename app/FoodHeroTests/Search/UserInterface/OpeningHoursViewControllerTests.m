//
//  OpeningHoursViewControllerTests.m
//  FoodHero
//
//  Created by Jorg on 19/10/14.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest.h>
#import "ControllerFactory.h"
#import "StubAssembly.h"
#import "TyphoonComponents.h"
#import "OpeningHoursViewController.h"
#import "OpeningHour.h"

@interface OpeningHoursViewControllerTests : XCTestCase

@end

@implementation OpeningHoursViewControllerTests {
    OpeningHoursViewController *_ctrl;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly assembly]];
    _ctrl = [ControllerFactory createOpeningHoursViewControllerTests];
    _ctrl.view.hidden = NO;
}

- (CGSize)preferredContentSizeFor:(NSArray *)openingHours {
    [_ctrl setOpeningHours:openingHours];
    CGSize size = _ctrl.preferredContentSize;
    return size;
}

- (void)test_preferredContentSize_ShouldCalculateCorrectSize_WhenOneLine {
    CGSize size1 = [self preferredContentSizeFor:@[[OpeningHour create:@"Monday" hours:@"1 am - 2 am" isToday:NO]]];
    CGSize size2 = [self preferredContentSizeFor:@[[OpeningHour create:@"Monday" hours:@"1 am - 2:30 am, 3 - 5 am" isToday:NO]]];
    CGSize size3 = [self preferredContentSizeFor:@[[OpeningHour create:@"Wednesday" hours:@"1 am - 2 am" isToday:NO]]];

    assertThatFloat(size2.width, is(greaterThan(@(size1.width))));
    assertThatFloat(size2.width, is(greaterThan(@(size3.width))));
    assertThatFloat((NSInteger) size1.height, is(equalTo(@((NSInteger) size2.height))));
    assertThatFloat((NSInteger) size2.height, is(equalTo(@((NSInteger) size3.height))));

}

- (void)test_preferredContentSize_ShouldCalculateCorrectSize_WhenSeveralLines {
    CGSize text1 = [self preferredContentSizeFor:@[[OpeningHour create:@"Saturday" hours:@"1 am" isToday:NO]]];
    CGSize text2 = [self preferredContentSizeFor:@[
            [OpeningHour create:@"Monday" hours:@"1 am" isToday:NO],
            [OpeningHour create:@"Tuesday" hours:@"1 am" isToday:NO]]];

    assertThatFloat(text2.width, is(lessThan(@(text1.width))));
    assertThatFloat(text2.height, is(greaterThan(@(text1.height))));
}

@end
