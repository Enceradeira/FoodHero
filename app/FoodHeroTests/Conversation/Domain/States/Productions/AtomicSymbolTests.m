//
//  AtomicSymbolTests.m
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

@interface AtomicSymbolTests : XCTestCase

@end

@implementation AtomicSymbolTests {
    TestToken *_token1;
    TestToken2 *_token2;
}

- (void)setUp
{
    [super setUp];
    _token1 =[TestToken new];
    _token2 =[TestToken2 new];
}

- (void)test_consume_ShouldReturnSymbolResultOnce_WhenThereWouldHaveBeenMoreMatchesToBeConsumed
{
    ReturnsActionForTokenOnceSymbol *symbol = [ReturnsActionForTokenOnceSymbol create:TestToken.class];

    assertThatBool([symbol consume:_token2].isTokenNotConsumed,is(equalToBool(YES)));
    assertThatBool([symbol consume:_token2].isTokenNotConsumed,is(equalToBool(YES)));
    assertThatBool([symbol consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    assertThatBool([symbol consume:_token1].isStateFinished,is(equalToBool(YES))); // would match as well but is not consumed
    assertThat(^(){[symbol consume:_token1];}, throwsExceptionOfType(DesignByContractException.class));
    assertThat(^(){[symbol consume:_token2];}, throwsExceptionOfType(DesignByContractException.class));
}

- (void)test_consume_ShouldReturnSymbolResultOnce_WhenThereWouldNotHaveBeenMoreMatchesToBeConsumed
{
    ReturnsActionForTokenOnceSymbol *symbol = [ReturnsActionForTokenOnceSymbol create:TestToken.class];

    assertThatBool([symbol consume:_token2].isTokenNotConsumed,is(equalToBool(YES)));
    assertThatBool([symbol consume:_token2].isTokenNotConsumed,is(equalToBool(YES)));
    assertThatBool([symbol consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    assertThatBool([symbol consume:_token2].isStateFinished,is(equalToBool(YES))); // would not match as there for is not consumed
    assertThat(^(){[symbol consume:_token1];}, throwsExceptionOfType(DesignByContractException.class));
    assertThat(^(){[symbol consume:_token2];}, throwsExceptionOfType(DesignByContractException.class));
}

@end
