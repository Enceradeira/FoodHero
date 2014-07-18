 //
//  ConcatenationTests.m
//  FoodHero
//
//  Created by Jorg on 18/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "Concatenation.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"
#import "ReturnsActionNeverSymbol.h"
#import "TestAction.h"
#import "TestToken.h"
#import "RepeatOnce.h"
#import "ReturnsActionForTokenSymbol.h"
#import "RepeatAlways.h"

 @interface ConcatenationTests : XCTestCase

@end

@implementation ConcatenationTests {
    TestToken *_token;
}

- (void)setUp {
    [super setUp];
    _token =[TestToken new];
}

- (void)test_consume_ShouldThrowException_WhenConcatenationEmpty
{
    Concatenation *concat = [Concatenation new];
    
    assertThat(^{[concat consume:_token];}, throwsExceptionOfType(DesignByContractException.class));
}

-(void)test_consume_ShouldReturnNil_WhenLastStateDoesntConsumeTokenOnSecondeConsume
{
    Concatenation *concat = [Concatenation create:
                                 [RepeatOnce create:[ReturnsActionForTokenSymbol create:_token.class]],
                                 [RepeatOnce create:[ReturnsActionForTokenSymbol create:_token.class]],
                                 [RepeatOnce create:[ReturnsActionForTokenSymbol create:_token.class]],nil];

    // consumed by first symbol
    assertThat([concat consume:_token], is(notNilValue()));
    // consumed by second symbol
    assertThat([concat consume:_token], is(notNilValue()));
    // consume by third symbol
    assertThat([concat consume:_token], is(notNilValue()));
    // not consumed by third symbol (which is last)
    assertThat([concat consume:_token], is(nilValue()));
}

-(void)test_consume_ShouldReturnActionFromFirstSymbol_WhenFirstSymbolConsumesToken{
    Concatenation *concat = [Concatenation create:
                                [RepeatOnce create:[ReturnsActionForTokenSymbol create:_token.class]],nil];

    assertThat([concat consume:_token], is(notNilValue()));
}

-(void)test_consume_ShouldReturnActionFromFirstSymbol_WhenFirstSymbolAlwaysConsumesToken{
    Concatenation *concat = [Concatenation create:
                                [RepeatAlways create:^(){return [ReturnsActionForTokenSymbol create:_token.class];}],nil];

    assertThat([concat consume:_token], is(notNilValue()));
    assertThat([concat consume:_token], is(notNilValue()));
    assertThat([concat consume:_token], is(notNilValue()));
}

-(void)test_consume_ShouldReturnNil_WhenFirstSymbolDoesntConsumeToken{
    Concatenation *concat = [Concatenation create:
                                [RepeatAlways create:^(){return [ReturnsActionNeverSymbol new];}],nil];

    assertThat([concat consume:_token], is(nilValue()));
}

-(void)test_consume_ShouldReturnActionFormSecondSymbol_WhenFirstSymbolDoesntConsumeTokenOnSecondConsume{
    id<Symbol> symbolA = [ReturnsActionForTokenSymbol create:_token.class];
    id<Symbol> symbolB = [ReturnsActionForTokenSymbol create:_token.class];

    Concatenation *concat = [Concatenation create:
                                 [RepeatOnce create:symbolA],
                                 [RepeatOnce create:symbolB],nil];

    [concat consume:_token];
    TestAction* action = [concat consume:_token];
    assertThat(action.sender, is(equalTo(symbolB)));
}

-(void)test_consume_ShouldReturnNil_WhenFirstSymbolDoesntConsumeAndSecondSymbolDoesntConsume{
     Concatenation *concat = [Concatenation create:
                                 [RepeatAlways create:^(){return [ReturnsActionNeverSymbol new];}],
                                 [RepeatOnce create:[ReturnsActionNeverSymbol new]],nil];

    assertThat([concat consume:_token], is(nilValue()));
    assertThat([concat consume:_token], is(nilValue()));
    assertThat([concat consume:_token], is(nilValue()));
}

-(void)test_consume_ShouldReturnActionFromSecondSymbol_WhenFirstSymbolIsOptional{
    id<Symbol> secondSymbol = [ReturnsActionForTokenSymbol create:_token.class];
    Concatenation *concat = [Concatenation create:
                                 [RepeatAlways create:^(){return [ReturnsActionNeverSymbol new];}],
                                 [RepeatOnce create:secondSymbol],nil];

    TestAction* action = [concat consume:_token];
    assertThat(action.sender, is(equalTo(secondSymbol)));
    
}

-(void)test_consume_ShouldReturnNil_WhenNoSymbolConsumeButAllAreOptional{
    Concatenation *concat = [Concatenation create:
                                  [RepeatAlways create:^(){return [ReturnsActionNeverSymbol new];}],
                                  [RepeatAlways create:^(){return [ReturnsActionNeverSymbol new];}],nil];

    assertThat([concat consume:_token], is(nilValue()));
}

@end
