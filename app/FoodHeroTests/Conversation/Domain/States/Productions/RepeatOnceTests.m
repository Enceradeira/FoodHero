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
#import "ReturnsAlwaysTokenNotConsumedSymbol.h"
#import "ReturnsActionForTokenOnceSymbol.h"
#import "RepeatAlways.h"
#import "TestToken2.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"
#import "ReturnsActionForTokenAlwaysSymbol.h"

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
            [ReturnsActionForTokenAlwaysSymbol create:_token1.class]];

    assertThatBool([repetition consume:_token2].isTokenNotConsumed,is(equalToBool(YES)));
    assertThatBool([repetition consume:_token2].isTokenNotConsumed,is(equalToBool(YES)));
    // begin of 1. repetition
    assertThatBool([repetition consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    assertThatBool([repetition consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    assertThatBool([repetition consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    // end of 1. repetition
    assertThatBool([repetition consume:_token2].isStateFinished,is(equalToBool(YES)));
    // no more repetitions
    assertThat(^(){[repetition consume:_token1];}, throwsExceptionOfType(DesignByContractException.class));
    assertThat(^(){[repetition consume:_token2];}, throwsExceptionOfType(DesignByContractException.class));
}

@end
