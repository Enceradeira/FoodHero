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
#import "InvalidConversationStateException.h"
#import "ReturnsAlwaysTokenNotConsumedSymbol.h"
#import "TestAction.h"
#import "TestToken.h"
#import "RepeatOnce.h"
#import "ReturnsActionForTokenOnceSymbol.h"
#import "RepeatAlways.h"
#import "TestToken2.h"
#import "TokenConsumed.h"
#import "ReturnsAlwaysStateFinishedSymbol.h"

 @interface ConcatenationTests : XCTestCase

@end

@implementation ConcatenationTests {
    TestToken *_token1;
    TestToken2 *_token2;
}

- (void)setUp {
    [super setUp];
    _token1 =[TestToken new];
    _token2 =[TestToken2 new];
}

- (void)test_consume_ShouldReturnConsumeFinished_WhenConcatenationEmpty
{
    Concatenation *concat = [Concatenation new];

    assertThatBool([concat consume:_token1].isStateFinished, equalToBool(YES));
}

-(void)test_consume_ShouldReturnConsumeFinished_WhenLastStateDoesntConsumeTokenOnSecondConsume
{
    Concatenation *concat = [Concatenation create:
                                 [RepeatOnce create:[ReturnsActionForTokenOnceSymbol create:_token1.class]],
                                 [RepeatOnce create:[ReturnsActionForTokenOnceSymbol create:_token1.class]],
                                 [RepeatOnce create:[ReturnsActionForTokenOnceSymbol create:_token1.class]],nil];

    // consumed by first symbol
    assertThatBool([concat consume:_token1].isTokenConsumed, is(equalToBool(YES)));
    // consumed by second symbol
    assertThatBool([concat consume:_token1].isTokenConsumed, is(equalToBool(YES)));
    // consume by third symbol
    assertThatBool([concat consume:_token1].isTokenConsumed, is(equalToBool(YES)));
    // not consumed by third symbol (which is last)
    assertThatBool([concat consume:_token1].isStateFinished, is(equalToBool(YES)));
}

-(void)test_consume_ShouldReturnTokenConsumedForFirstSymbol_WhenFirstSymbolConsumesToken{
    Concatenation *concat = [Concatenation create:
                                [RepeatOnce create:[ReturnsActionForTokenOnceSymbol create:_token1.class]],nil];

    assertThatBool([concat consume:_token1].isTokenConsumed, is(equalToBool(YES)));
    assertThatBool([concat consume:_token1].isStateFinished, is(equalToBool(YES)));
}

-(void)test_consume_ShouldReturnTokenConsumedForFirstSymbol_WhenFirstSymbolAlwaysConsumesToken{
    Concatenation *concat = [Concatenation create:
                                [RepeatAlways create:^(){return [ReturnsActionForTokenOnceSymbol create:_token1.class];}],nil];

    assertThatBool([concat consume:_token1].isTokenConsumed, is(equalToBool(YES)));
    assertThatBool([concat consume:_token1].isTokenConsumed, is(equalToBool(YES)));
    assertThatBool([concat consume:_token1].isTokenConsumed, is(equalToBool(YES)));
}

-(void)test_consume_ShouldReturnTokenNotConsumed_WhenFirstSymbolDoesntConsumeToken{
    Concatenation *concat = [Concatenation create:
                                [RepeatOnce create:[ReturnsAlwaysTokenNotConsumedSymbol new]],nil];

    assertThatBool([concat consume:_token1].isTokenNotConsumed, is(equalToBool(YES)));
}

-(void)test_consume_ShouldThrowException_WhenFirstSymbolConsumesTokenButSecondDoesnt{
    Concatenation *concat = [Concatenation create:
                                [RepeatOnce create:[ReturnsActionForTokenOnceSymbol create:_token1.class]],
                                [RepeatOnce create:[ReturnsActionForTokenOnceSymbol create:_token2.class]],nil];

    assertThatBool([concat consume:_token1].isTokenConsumed, is(equalToBool(YES)));
    assertThat(^(){[concat consume:_token1];},throwsExceptionOfType(InvalidConversationStateException.class));
}

-(void)test_consume_ShouldReturnActionFormSecondSymbol_WhenFirstSymbolDoesntConsumeTokenOnSecondConsume{
    id<Symbol> symbolA = [ReturnsActionForTokenOnceSymbol create:_token1.class];
    id<Symbol> symbolB = [ReturnsActionForTokenOnceSymbol create:_token1.class];

    Concatenation *concat = [Concatenation create:
                                 [RepeatOnce create:symbolA],
                                 [RepeatOnce create:symbolB],nil];

    [concat consume:_token1];
    TestAction* action = ((TokenConsumed*)[concat consume:_token1]).action;
    assertThat(action.sender, is(equalTo(symbolB)));
}

-(void)test_consume_ShouldReturnTokenNotConsumed_WhenFirstSymbolDoesntConsumeAndSecondSymbolDoesntConsume{
     Concatenation *concat = [Concatenation create:
                                 [RepeatOnce create:[ReturnsAlwaysTokenNotConsumedSymbol new]],
                                 [RepeatOnce create:[ReturnsAlwaysTokenNotConsumedSymbol new]],nil];

    assertThatBool([concat consume:_token1].isTokenNotConsumed, is(equalToBool(YES)));
    assertThatBool([concat consume:_token1].isTokenNotConsumed, is(equalToBool(YES)));
    assertThatBool([concat consume:_token1].isTokenNotConsumed, is(equalToBool(YES)));
    assertThatBool([concat consume:_token1].isTokenNotConsumed, is(equalToBool(YES)));
}

-(void)test_consume_ShouldReturnTokenConsumed_WhenFirstTwoSymbolsAreOptional{
    Concatenation *concat = [Concatenation create:
            [RepeatAlways create:^(){return [ReturnsAlwaysStateFinishedSymbol new];}],
            [RepeatAlways create:^(){return [ReturnsAlwaysStateFinishedSymbol new];}],
            [RepeatOnce create:[ReturnsActionForTokenOnceSymbol create:_token1.class]],nil];

    assertThatBool([concat consume:_token1].isTokenConsumed, is(equalToBool(YES)));
    assertThatBool([concat consume:_token1].isStateFinished, is(equalToBool(YES)));
}

-(void)test_consume_ShouldReturnActionFromSecondSymbol_WhenFirstSymbolIsOptional{
    id<Symbol> secondSymbol = [ReturnsActionForTokenOnceSymbol create:_token1.class];
    Concatenation *concat = [Concatenation create:
                                 [RepeatAlways create:^(){return [ReturnsAlwaysStateFinishedSymbol new];}],
                                 [RepeatOnce create:secondSymbol],nil];

    TestAction* action = ((TokenConsumed*)[concat consume:_token1]).action;
    assertThat(action.sender, is(equalTo(secondSymbol)));
    
}

-(void)test_consume_ShouldReturnStateFinished_WhenNoSymbolConsumeButAllAreOptional{
    Concatenation *concat = [Concatenation create:
                                  [RepeatAlways create:^(){return [ReturnsAlwaysStateFinishedSymbol new];}],
                                  [RepeatAlways create:^(){return [ReturnsAlwaysStateFinishedSymbol new];}],nil];

    assertThatBool([concat consume:_token1].isStateFinished, is(equalToBool(YES)));
}

-(void)test_consume_ShouldThrowException_WhenConsumeIsCalledInStateFinished
{
    Concatenation *concat = [Concatenation create:
                                [RepeatAlways create:^(){return [ReturnsAlwaysStateFinishedSymbol new];}],nil];

    [concat consume:_token1];
    assertThat(^(){[concat consume:_token1];},throwsExceptionOfType(InvalidConversationStateException.class));
}

-(void)test_consume_ShouldNotConsumeToken_WhenFirstSymbolOptionalAndSecondDoesntConsume{
          Concatenation *concat = [Concatenation create:
                                  [RepeatAlways create:^(){return [ReturnsAlwaysTokenNotConsumedSymbol new];}],
                                  [RepeatOnce create:[ReturnsAlwaysTokenNotConsumedSymbol new]],nil];

    assertThatBool([concat consume:_token1].isTokenNotConsumed, is(equalToBool(YES)));
}

@end
