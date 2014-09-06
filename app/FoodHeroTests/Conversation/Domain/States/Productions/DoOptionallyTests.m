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
#import "InvalidConversationStateException.h"
#import "ReturnsActionForTokenAlwaysSymbol.h"
#import "DoOptionally.h"

@interface DoOptionallyTests : XCTestCase

@end

@implementation DoOptionallyTests {
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
    DoOptionally *repetition = [DoOptionally create:
            [ReturnsActionForTokenAlwaysSymbol create:_token1.class]];

    // begin of 1. repetition
    assertThatBool([repetition consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    assertThatBool([repetition consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    assertThatBool([repetition consume:_token1].isTokenConsumed,is(equalToBool(YES)));
    // end of 1. repetition
    assertThatBool([repetition consume:_token2].isStateFinished,is(equalToBool(YES)));
    // no more repetitions
    assertThat(^(){[repetition consume:_token1];}, throwsExceptionOfType(InvalidConversationStateException.class));
    assertThat(^(){[repetition consume:_token2];}, throwsExceptionOfType(InvalidConversationStateException.class));
}

-(void)test_consume_ShouldReturnFinished_WhenTokenNotConsumed{
    DoOptionally *repetition = [DoOptionally create:
            [ReturnsAlwaysTokenNotConsumedSymbol new]];

    assertThatBool([repetition consume:_token2].isStateFinished,is(equalToBool(YES)));
}

@end
