//
//  FoodHeroTests.m
//  FoodHeroTests
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import <Typhoon.h>
#import "ConversationViewController.h"
#import "ApplicationAssembly.h"
#import "ControllerFactory.h"

@interface ApplicationAssemblyTests : XCTestCase

@end

@implementation ApplicationAssemblyTests

- (void)test_Storyboard_ShouldLoadConversationViewControllerCorrectly
{
    TyphoonAssembly* assembly = [ApplicationAssembly assembly];
    ConversationViewController *ctrl = [ControllerFactory createConversationViewController:assembly];
    
    assertThat(ctrl, is(notNilValue()));
}

@end
