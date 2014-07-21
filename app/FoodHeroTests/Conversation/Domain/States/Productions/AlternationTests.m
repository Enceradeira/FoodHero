//
//  AlternationTests.m
//  FoodHero
//
//  Created by Jorg on 18/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "Alternation.h"
#import "TestAction.h"
#import "ReturnsAlwaysTokenNotConsumedSymbol.h"
#import "ReturnsActionForTokenOnceSymbol.h"
#import "RepeatOnce.h"
#import "RepeatAlways.h"
#import "TestToken.h"
#import "TokenConsumed.h"
#import "ReturnsAlwaysStateFinishedSymbol.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"

@interface AlternationTests : XCTestCase

@end

@implementation AlternationTests{
    TestToken *_token;
}

- (void)setUp {
    [super setUp];
    _token = [TestToken new];
}

- (void)test_consume_ShouldReturnStateFinished_WhenAlternationEmpty {
    Alternation *alternation = [Alternation create:nil];

    assertThatBool([alternation consume:_token].isStateFinished, is(equalToBool(YES)));
}

- (void)test_consume_ShouldAlwaysReturnResultFromFirstAlternative_WhenTwoAlternativesYieldResults {
    __block id<Symbol> createdSymbol1;

    Alternation *alternation = [Alternation create:
                                     [RepeatAlways create:^(){return createdSymbol1 = [ReturnsActionForTokenOnceSymbol create:_token.class];}],
                                     [RepeatAlways create:^(){return [ReturnsActionForTokenOnceSymbol create:_token.class];}], nil];

    TestAction *action = ((TokenConsumed *)[alternation consume:_token]).action;
    assertThat(action.sender, is(equalTo(createdSymbol1)));

    action = ((TokenConsumed *)[alternation consume:_token]).action;;
    assertThat(action.sender, is(equalTo(createdSymbol1)));
}

- (void)test_consume_ShouldReturnResultFromSecondAlternative_WhenFirstAlternativeYieldsNoResult {

    __block id<Symbol> secondCreatedSymbol;

    Alternation *alternation = [Alternation create:
                                    [RepeatOnce create:[ReturnsAlwaysTokenNotConsumedSymbol new]],
                                    [RepeatAlways create:^(){return secondCreatedSymbol =[ReturnsActionForTokenOnceSymbol create:_token.class];}], nil];

    TestAction *action = ((TokenConsumed *)[alternation consume:_token]).action;
    assertThat(action.sender, is(equalTo(secondCreatedSymbol)));

    action = ((TokenConsumed *)[alternation consume:_token]).action;
    assertThat(action.sender, is(equalTo(secondCreatedSymbol)));
}

- (void)test_consume_ShouldReturnTokenNotConsumed_WhenBothAlternativesDontConsumeToken {

    Alternation *alternation = [Alternation create:
                                    [RepeatOnce create:[ReturnsAlwaysTokenNotConsumedSymbol new]],
                                    [RepeatOnce create:[ReturnsAlwaysTokenNotConsumedSymbol new]], nil];

    assertThatBool([alternation consume:_token].isTokenNotConsumed, is(equalToBool(YES)));
    assertThatBool([alternation consume:_token].isTokenNotConsumed, is(equalToBool(YES)));
    assertThatBool([alternation consume:_token].isTokenNotConsumed, is(equalToBool(YES)));
}

- (void)test_consume_ShouldReturnStateFinished_WhenFirstAlternativeReturnsStateFinished {

    Alternation *alternation = [Alternation create:
                                    [RepeatOnce create:[ReturnsAlwaysStateFinishedSymbol new]],
                                    [RepeatAlways create:^(){return [ReturnsAlwaysTokenNotConsumedSymbol new];}], nil];

    assertThatBool([alternation consume:_token].isStateFinished, is(equalToBool(YES)));
}

- (void)test_consume_ShouldReturnStateFinished_WhenFirstAlternativeStopsYieldingResult{

    Alternation *alternation = [Alternation create:
                                    [RepeatOnce create:[ReturnsActionForTokenOnceSymbol create:_token.class]],
                                    [RepeatAlways create:^(){return [ReturnsActionForTokenOnceSymbol create:_token.class];}], nil];

    assertThatBool([alternation consume:_token].isTokenConsumed, is(equalToBool(YES)));
    assertThatBool([alternation consume:_token].isStateFinished, is(equalToBool(YES)));
}

- (void)test_consume_ShouldReturnStateFinished_WhenSecondAlternativeStopsYieldingResult{

    Alternation *alternation = [Alternation create:
                                    [RepeatOnce create: [ReturnsAlwaysTokenNotConsumedSymbol new]],
                                    [RepeatOnce create:[ReturnsActionForTokenOnceSymbol create:_token.class]],
                                    [RepeatAlways create:^(){return [ReturnsActionForTokenOnceSymbol create:_token.class];}], nil];

    assertThatBool([alternation consume:_token].isTokenConsumed, is(equalToBool(YES)));
    assertThatBool([alternation consume:_token].isStateFinished, is(equalToBool(YES)));
}

- (void)test_consume_ShouldReturnStateFinished_WhenLastAlternativeStopsYieldingResult{

    Alternation *alternation = [Alternation create:
                                    [RepeatOnce create:[ReturnsAlwaysTokenNotConsumedSymbol new]],
                                    [RepeatOnce create:[ReturnsAlwaysTokenNotConsumedSymbol new]],
                                    [RepeatOnce create:[ReturnsActionForTokenOnceSymbol create:_token.class]], nil];


    assertThatBool([alternation consume:_token].isTokenConsumed, is(equalToBool(YES)));
    assertThatBool([alternation consume:_token].isStateFinished, is(equalToBool(YES)));
}

-(void)test_consume_ShouldThrowException_WhenConsumeIsCalledInStateFinished
{
    Alternation *alternation = [Alternation create:nil];

    assertThatBool([alternation consume:_token].isStateFinished, is(equalToBool(YES)));
    assertThat(^(){[alternation consume:_token];}, throwsExceptionOfType([DesignByContractException class]));
}

@end
