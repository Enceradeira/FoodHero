//
//  RepeatOnceTests.m
//  FoodHero
//
//  Created by Jorg on 18/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "RepeatOnce.h"
#import "TestToken.h"
#import "ReturnsActionNeverSymbol.h"
#import "ReturnsActionForTokenSymbol.h"
#import "RepeatAlways.h"
#import "TestToken2.h"

@interface RepeatOnceTests : XCTestCase

@end

@implementation RepeatOnceTests {
    TestToken *_token1;
    TestToken2 *_token2;
}

- (void)setUp
{
    [super setUp];
    _token1 =[TestToken new];
    _token2 =[TestToken2 new];
}

- (void)test_consume_ShouldReturnSymbolResultOnce
{
    RepeatOnce *repetition = [RepeatOnce create:
            [RepeatAlways create:^(){
                return [ReturnsActionForTokenSymbol create:_token1.class];}]];

    assertThat([repetition consume:_token2],is(nilValue()));
    assertThat([repetition consume:_token1],is(notNilValue()));
    assertThat([repetition consume:_token1],is(notNilValue()));
    assertThat([repetition consume:_token2],is(nilValue()));
    assertThat([repetition consume:_token1],is(nilValue()));
    assertThat([repetition consume:_token1],is(nilValue()));
}

-(void)test_consume_ShouldAlwaysReturnNil_WennSymbolResultNil{
    RepeatOnce *repetition = [RepeatOnce create:[ReturnsActionNeverSymbol new]];

    assertThat([repetition consume:_token1],is(nilValue()));
    assertThat([repetition consume:_token1],is(nilValue()));
}


@end
