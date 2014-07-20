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
#import "ReturnsAlwaysTokenNotConsumedSymbol.h"
#import "ReturnsActionForTokenSymbolOnce.h"
#import "ReturnsActionForTokenSymbolAlways.h"
#import "TestToken2.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"

@interface RepeatAlwaysTests : XCTestCase

@end

@implementation RepeatAlwaysTests {
    TestToken *_token1;
    TestToken2 *_token2;
}

- (void)setUp {
    [super setUp];
    _token1 = [TestToken new];
    _token2 =[TestToken2 new];
}

- (void)test_consume_ShouldReturnSymbolResultServeralTimes
{
    RepeatAlways *repetition = [RepeatAlways create:
            ^(){return [ReturnsActionForTokenSymbolOnce create:_token1.class];}];

    // 1. repetition
    assertThatBool([repetition consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    // 2. repetition (because  ReturnsActionForTokenSymbolOnce only would consume once)
    assertThatBool([repetition consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    // 3. repetition (because  ReturnsActionForTokenSymbolOnce only would consume once)
    assertThatBool([repetition consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    // end of repetitions (because _token2 is never consumed)
    assertThatBool([repetition consume:_token2].isStateFinished,is(equalToBool(YES)));
    // no more consume allowed after state has finished
    assertThat(^(){[repetition consume:_token1];}, throwsExceptionOfType(DesignByContractException.class));
    assertThat(^(){[repetition consume:_token2];}, throwsExceptionOfType(DesignByContractException.class));
}

-(void)test_consume_ShouldReturnTokenConsumed_WhenTokenIsAlwaysConsumed{
    RepeatAlways *repetition = [RepeatAlways create:
            ^(){return [ReturnsActionForTokenSymbolOnce create:_token1.class];}];

    assertThatBool([repetition consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    assertThatBool([repetition consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    assertThatBool([repetition consume:_token1].isTokenConsumed,is(equalToBool(YES)));
}

-(void)test_consume_ShouldReturnTokenStateFinished_WhenTokenIsAlwaysNotConsumed{
    RepeatAlways *repetition = [RepeatAlways create:
            ^(){return [ReturnsActionForTokenSymbolOnce create:_token1.class];}];

    assertThatBool([repetition consume:_token2].isStateFinished,is(equalToBool(YES)));
}

@end
