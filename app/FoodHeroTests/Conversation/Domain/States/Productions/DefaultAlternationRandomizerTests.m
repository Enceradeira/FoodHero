//
//  AlternationTests.m
//  FoodHero
//
//  Created by Jorg on 18/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "DefaultAlternationRandomizer.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"
#import "ReturnsAlwaysStateFinishedSymbol.h"
#import "TagAndSymbol.h"

@interface DefaultAlternationRandomizerTests : XCTestCase

@end

@implementation DefaultAlternationRandomizerTests {
    DefaultAlternationRandomizer *_randomizer;
}

- (void)setUp {
    [super setUp];

    _randomizer = [DefaultAlternationRandomizer new];
}

- (TagAndSymbol*)tagAndSymbolFor:(ReturnsAlwaysStateFinishedSymbol *)symbol{
    return [[TagAndSymbol alloc] initWithTag:@"Tag" symbol:symbol];
}

- (void)test_chooseOneSymbol_ShouldChooseASymbolRandomly {
    id<Symbol> symbol1 = [ReturnsAlwaysStateFinishedSymbol new];
    id<Symbol> symbol2 = [ReturnsAlwaysStateFinishedSymbol new];
    NSArray *symbols = [NSArray arrayWithObjects:[self tagAndSymbolFor:symbol1],[self tagAndSymbolFor:symbol2],nil];

    NSUInteger nrTests = 10;
    NSUInteger nrSymbol1 = 0;
    NSUInteger nrSymbol2 = 0;
    for( NSUInteger i=0; i<nrTests; i++)
    {
        id <Symbol> chosenSymbol = [_randomizer chooseOneSymbol:symbols];
        assertThat(chosenSymbol, is(notNilValue()));
        if( chosenSymbol == symbol1){
            nrSymbol1++;
        }
        if( chosenSymbol == symbol2){
            nrSymbol2++;
        }
    }
    assertThatUnsignedInt(nrSymbol1, greaterThan(@0));
    assertThatUnsignedInt(nrSymbol2, greaterThan(@0));
    assertThatUnsignedInt(nrSymbol1+nrSymbol2, is(equalToUnsignedInt(nrTests)));
}

- (void)test_chooseOneSymbol_ShouldOnlySymbol_WhenOneSymbolInList {
    id<Symbol> onlySymbol = [ReturnsAlwaysStateFinishedSymbol new];
    NSArray *symbols = [NSArray arrayWithObjects:[self tagAndSymbolFor:onlySymbol],nil];

    id <Symbol> chosenSymbol = [_randomizer chooseOneSymbol:symbols];
    assertThat(chosenSymbol, is(equalTo(onlySymbol)));
}

- (void)test_chooseOneSymbol_ShouldThrowExcepction_WhenListIsEmpty {
    assertThat(^(){[_randomizer chooseOneSymbol:[NSArray new]];}, throwsExceptionOfType(DesignByContractException.class));
}

@end
