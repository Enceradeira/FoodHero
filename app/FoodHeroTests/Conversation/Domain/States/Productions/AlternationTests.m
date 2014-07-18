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
#import "ReturnsActionNeverSymbol.h"
#import "ReturnsActionForTokenSymbol.h"
#import "RepeatOnce.h"
#import "RepeatAlways.h"
#import "TestToken.h"

@interface AlternationTests : XCTestCase

@end

@implementation AlternationTests{
    TestToken *_token;
}

- (void)setUp {
    [super setUp];
    _token = [TestToken new];
}

- (void)test_consume_ShouldReturnNilWhenAlternationEmpty {
    Alternation *alternation = [Alternation create:nil];

    assertThat([alternation consume:_token], is(nilValue()));
    assertThat([alternation consume:_token], is(nilValue()));
}

- (void)test_consume_ShouldAlwaysReturnResultFromFirstAlternative_WhenTwoAlternativesYieldResults {
    __block id<Symbol> createdSymbol1;

    Alternation *alternation = [Alternation create:
                                     [RepeatAlways create:^(){return createdSymbol1 = [ReturnsActionForTokenSymbol create:_token.class];}],
                                     [RepeatAlways create:^(){return [ReturnsActionForTokenSymbol create:_token.class];}], nil];

    TestAction *action = [alternation consume:_token];
    assertThat(action.sender, is(equalTo(createdSymbol1)));

    action = [alternation consume:_token];
    assertThat(action.sender, is(equalTo(createdSymbol1)));
}

- (void)test_consume_ShouldReturnResultFromSecondAlternative_WhenFirstAlternativeYieldsNoResult {

    __block id<Symbol> secondCreatedSymbol;

    Alternation *alternation = [Alternation create:
                                    [RepeatAlways create:^(){return [ReturnsActionNeverSymbol new];}],
                                    [RepeatAlways create:^(){return secondCreatedSymbol =[ReturnsActionForTokenSymbol create:_token.class];}], nil];

    TestAction *action = [alternation consume:_token];
    assertThat(action.sender, is(equalTo(secondCreatedSymbol)));

    action = [alternation consume:_token];
    assertThat(action.sender, is(equalTo(secondCreatedSymbol)));
}

- (void)test_consume_ShouldReturnNil_WhenNoAlternativeYieldsResults {

    Alternation *alternation = [Alternation create:
                                    [RepeatAlways create:^(){return [ReturnsActionNeverSymbol new];}],
                                    [RepeatAlways create:^(){return [ReturnsActionNeverSymbol new];}], nil];

    assertThat([alternation consume:_token], is(nilValue()));
    assertThat([alternation consume:_token], is(nilValue()));
}

- (void)test_consume_ShouldReturnNil_WhenFirstAlternativeStopsYieldingResult{

    Alternation *alternation = [Alternation create:
                                    [RepeatOnce create:[ReturnsActionForTokenSymbol create:_token.class]],
                                    [RepeatAlways create:^(){return [ReturnsActionForTokenSymbol create:_token.class];}], nil];

    assertThat([alternation consume:_token], is(notNilValue()));
    assertThat([alternation consume:_token], is(nilValue()));
}

- (void)test_consume_ShouldReturnNil_WhenSecondAlternativeStopsYieldingResult{

    Alternation *alternation = [Alternation create:
                                    [RepeatAlways create:^(){return [ReturnsActionNeverSymbol new];}],
                                    [RepeatOnce create:[ReturnsActionForTokenSymbol create:_token.class]],
                                    [RepeatAlways create:^(){return [ReturnsActionForTokenSymbol create:_token.class];}], nil];

    TestAction *action = [alternation consume:_token];
    assertThat(action, is((notNilValue())));
    assertThat([alternation consume:_token], is(nilValue()));
    assertThat([alternation consume:_token], is(nilValue()));
}

- (void)test_consume_ShouldReturnNil_WhenLastAlternativeStopsYieldingResult{

    Alternation *alternation = [Alternation create:
                                    [RepeatAlways create:^(){return [ReturnsActionNeverSymbol new];}],
                                    [RepeatOnce create:[ReturnsActionNeverSymbol new]],
                                    [RepeatOnce create:[ReturnsActionForTokenSymbol create:_token.class]], nil];


    assertThat([alternation consume:_token], is((notNilValue())));
    assertThat([alternation consume:_token], is(nilValue()));
}

@end
