//
//  RandomAlternationTests.m
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
#import "RepeatAlways.h"
#import "TestToken.h"
#import "TokenConsumed.h"
#import "RandomAlternation.h"
#import "StubAssembly.h"
#import "TyphoonComponents.h"
#import "AlternationRandomizerStub.h"
#import "RepeatOnce.h"

@interface RandomAlternationTests : XCTestCase

@end

@implementation RandomAlternationTests{
    TestToken *_token;
    AlternationRandomizerStub *_randomizerStub;
}

- (void)setUp {
    [super setUp];
    _token = [TestToken new];

    [TyphoonComponents configure:[StubAssembly new]];

    _randomizerStub = [(id<ApplicationAssembly>) [TyphoonComponents factory] alternationRandomizer];
}

- (void)test_consume_ShouldChooseSecondAlternative_WhenSecondIsChoosenByRandom {
    __block id<Symbol> createdSymbol1;
    __block id<Symbol> createdSymbol2;

    RandomAlternation *alternation = [RandomAlternation create:
                                     @"1",[RepeatAlways create:^(){return createdSymbol1 = [ReturnsActionForTokenOnceSymbol create:_token.class];}],
                                     @"2",[RepeatAlways create:^(){return createdSymbol2 = [ReturnsActionForTokenOnceSymbol create:_token.class];}], nil];

    [_randomizerStub injectChoice:@"2"];

    TestAction *action = ((TokenConsumed *)[alternation consume:_token]).action;
    assertThat(action.sender, is(equalTo(createdSymbol2)));

    action = ((TokenConsumed *)[alternation consume:_token]).action;;
    assertThat(action.sender, is(equalTo(createdSymbol2)));
}


- (void)test_consume_ShouldChooseFirstAlternative_WhenFirstIsChoosenByRandom {
    __block id<Symbol> createdSymbol1;
    __block id<Symbol> createdSymbol2;

    RandomAlternation *alternation = [RandomAlternation create:
                                     @"1",[RepeatAlways create:^(){return createdSymbol1 = [ReturnsActionForTokenOnceSymbol create:_token.class];}],
                                     @"2",[RepeatAlways create:^(){return createdSymbol2 = [ReturnsActionForTokenOnceSymbol create:_token.class];}], nil];

    [_randomizerStub injectChoice:@"1"];

    TestAction *action = ((TokenConsumed *)[alternation consume:_token]).action;
    assertThat(action.sender, is(equalTo(createdSymbol1)));

    action = ((TokenConsumed *)[alternation consume:_token]).action;;
    assertThat(action.sender, is(equalTo(createdSymbol1)));
}

-(void)test_consume_ShouldNotRepeatChoice_WhenChoosenAlternativeDoesntConsumeToken{

    id<Symbol> symbol1 = [ReturnsActionForTokenOnceSymbol create:_token.class];
    id<Symbol> symbol2 = [ReturnsAlwaysTokenNotConsumedSymbol new];

    RandomAlternation *alternation = [RandomAlternation create:
                                     @"1",[RepeatOnce create:symbol1],
                                     @"2",[RepeatOnce create:symbol2], nil];

    [_randomizerStub injectChoice:@"2"];   // alternative 2 doesn't consume and is therefore not a good alternative

    TestAction *action = ((TokenConsumed *)[alternation consume:_token]).action;
    assertThat(action.sender, is(equalTo(symbol1)));
}

@end
