//
//  RepeatAlwaysTests.m
//  FoodHero
//
//  Created by Jorg on 18/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "TestToken.h"
#import "RepeatAlways.h"
#import "ReturnsActionNeverSymbol.h"
#import "ReturnsActionForTokenSymbol.h"

@interface RepeatAlwaysTests : XCTestCase

@end

@implementation RepeatAlwaysTests {
    TestToken *_token;
}

- (void)setUp {
    [super setUp];
    _token = [TestToken new];
}

- (void)test_consume_SholdAlwaysReturnAction_WhenSymbolAlwaysReturnsAction {
    RepeatAlways *repetition = [RepeatAlways create:^(){return [ReturnsActionForTokenSymbol create:_token.class];}];

    assertThat([repetition consume:_token],is(notNilValue()) );
    assertThat([repetition consume:_token],is(notNilValue()) );
}

- (void)test_consume_ShouldAlwaysReturnNil_WhenSymbolAlwaysReturnsNil{
        RepeatAlways *repetition = [RepeatAlways create:^(){return [ReturnsActionNeverSymbol new];}];

    assertThat([repetition consume:_token],is(nilValue()) );
    assertThat([repetition consume:_token],is(nilValue()) );
}

@end
