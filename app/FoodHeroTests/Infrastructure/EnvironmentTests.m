//
//  EnvironmentTests.m
//  FoodHero
//
//  Created by Jorg on 14/06/15.
//  Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Environment.h"
#import <OCHamcrest/OCHamcrest.h>

@interface EnvironmentTests : XCTestCase

@end

@implementation EnvironmentTests {
    Environment *_environment;
}

- (void)setUp {
    [super setUp];
    _environment = [Environment new];
}

-(void)test_systemVersion_ShouldBeEqualToDeviceVersion{
    assertThat(_environment.systemVersion, is(equalTo([[UIDevice currentDevice] systemVersion])));
}

- (void)test_isVersionOrHigher_ShouldReturnTrue_WhenSystemVersionIsEqualOrGreater{

    _environment.systemVersion = @"8.3";
    assertThatBool([_environment isVersionOrHigher:8 minor:0], is(equalTo(@true)));

    _environment.systemVersion = @"8.0";
    assertThatBool([_environment isVersionOrHigher:8 minor:0], is(equalTo(@true)));
}

- (void)test_isVersionOrHigher_ShouldReturnFalse_WhenSystemVersionIsSmaller{

    _environment.systemVersion = @"7.9";
    assertThatBool([_environment isVersionOrHigher:8 minor:0], is(equalTo(@false)));
}



@end
