//
//  RestaurantDetailTableViewControllerTests.m
//  FoodHero
//
//  Created by Jorg on 04/10/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest.h>
#import "ControllerFactory.h"
#import "StubAssembly.h"
#import "TyphoonComponents.h"
#import "RestaurantDetailTableViewController.h"
#import "RestaurantBuilder.h"

@interface RestaurantDetailTableViewControllerTests : XCTestCase

@end

@implementation RestaurantDetailTableViewControllerTests {
    RestaurantDetailTableViewController *_ctrl;
    Restaurant *_restaurant;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly assembly]];
    _ctrl = [ControllerFactory createRestaurantDetailTableViewController];
    _ctrl.view.hidden = NO;

    _restaurant = [[RestaurantBuilder alloc] build];
    [_ctrl setRestaurant:_restaurant];
}

- (void)test_name_ShouldBeRestaurantName {
    assertThatUnsignedInt(_ctrl.name.text.length, is(greaterThan(@0)));
    assertThat(_ctrl.name.text, is(equalTo(_restaurant.name)));
}

- (void)test_address_ShouldBeRestaurantAddress {
    assertThatUnsignedInt(_ctrl.address.text.length, is(greaterThan(@0)));
    assertThat(_ctrl.address.text, is(equalTo(_restaurant.address)));
}

- (void)test_openingStatus_ShouldBeRestaurantOpeningStatus {
    assertThatUnsignedInt(_ctrl.openingStatus.text.length, is(greaterThan(@0)));
    assertThat(_ctrl.openingStatus.text, is(equalTo(_restaurant.openingStatus)));
}

- (void)test_openingHours_ShouldBeRestaurantOpeningHours {
    assertThatUnsignedInt(_ctrl.openingHours.text.length, is(greaterThan(@0)));
    assertThat(_ctrl.openingHours.text, is(equalTo(_restaurant.openingHoursToday)));
}


- (void)test_openingHours_ShouldDisplaySeeOpeningHoursHere_WhenRestaurantClosedToday {
    _restaurant = [[[RestaurantBuilder alloc] withOpeningHoursToday:@""] build];
    [_ctrl setRestaurant:_restaurant];

    assertThatUnsignedInt(_ctrl.openingHours.text.length, is(greaterThan(@0)));
    assertThat(_ctrl.openingHours.text, is(equalTo(@"see opening hours here")));
}

- (void)test_phoneNumber_ShouldBeRestaurantPhoneNumber {
    assertThatUnsignedInt(_ctrl.phoneNumber.text.length, is(greaterThan(@0)));
    assertThat(_ctrl.phoneNumber.text, is(equalTo(_restaurant.phoneNumber)));
}

- (void)test_url_ShouldBeRestaurantPhoneNumber {
    assertThatUnsignedInt(_ctrl.url.text.length, is(greaterThan(@0)));
    assertThat(_ctrl.url.text, is(equalTo(_restaurant.urlForDisplaying)));
}

- (void)test_direction_ShouldBeDistanceInMiles_WhenMoreThan1MileAway {
    _restaurant = [[[RestaurantBuilder alloc] withDistance:2000] build];
    [_ctrl setRestaurant:_restaurant];

    assertThat(_ctrl.directions.text, is(equalTo(@"1.2 miles away")));
}

- (void)test_direction_ShouldBeDistanceInMiles_WhenLessThanHalfAMileAway {
    _restaurant = [[[RestaurantBuilder alloc] withDistance:300] build];
    [_ctrl setRestaurant:_restaurant];

    assertThat(_ctrl.directions.text, is(equalTo(@"328 yards away")));
}

-(void)test_phoneButton_ShouldBeHidden_WhenNoPhoneNumberAvailable{
    _restaurant = [[[RestaurantBuilder alloc] withPhoneNumber:@""] build];
    [_ctrl setRestaurant:_restaurant];

    assertThatBool(_ctrl.phoneButton.hidden, is(equalTo(@(YES))));
}

-(void)test_phoneButton_ShouldNotBeHidden_WhenPhoneNumberAvailable{
    _restaurant = [[[RestaurantBuilder alloc] withPhoneNumber:@"07872 222122"] build];
    [_ctrl setRestaurant:_restaurant];

    assertThatBool(_ctrl.phoneButton.hidden, is(equalTo(@(NO))));
}

-(void)test_urlButton_ShouldBeHidden_WhenNoUrlAvailable{
    _restaurant = [[[RestaurantBuilder alloc] withUrlForDisplaying:@""] build];
    [_ctrl setRestaurant:_restaurant];

    assertThatBool(_ctrl.urlButton.hidden, is(equalTo(@(YES))));
}

-(void)test_urlButton_ShouldNotBeHidden_WhenUrlAvailable{
    _restaurant = [[[RestaurantBuilder alloc] withUrlForDisplaying:@"www.test.com"] build];
    [_ctrl setRestaurant:_restaurant];

    assertThatBool(_ctrl.urlButton.hidden, is(equalTo(@(NO))));
}

@end
