//
//  AlternationTests.m
//  FoodHero
//
//  Created by Jorg on 18/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "DefaultRandomizer.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"
#import "TagAndToken.h"
#import "FHConfirmation.h"

@interface DefaultRandomizerTests : XCTestCase

@end

@implementation DefaultRandomizerTests {
    DefaultRandomizer *_randomizer;
}

- (void)setUp {
    [super setUp];

    _randomizer = [DefaultRandomizer new];
}

- (TagAndToken *)tagAndTokenFor:(ConversationToken *)symbol {
    return [[TagAndToken alloc] initWithTag:@"Tag" token:symbol];
}

- (void)test_chooseOneSymbol_ShouldChooseASymbolRandomly {
    ConversationToken *symbol1 = [FHConfirmation new];
    ConversationToken *symbol2 = [FHConfirmation new];
    NSArray *symbols = @[[self tagAndTokenFor:symbol1], [self tagAndTokenFor:symbol2]];

    NSUInteger nrTests = 10;
    NSUInteger nrSymbol1 = 0;
    NSUInteger nrSymbol2 = 0;
    for (NSUInteger i = 0; i < nrTests; i++) {
        id chosenSymbol = [_randomizer chooseOneToken:symbols];
        assertThat(chosenSymbol, is(notNilValue()));
        if (chosenSymbol == symbol1) {
            nrSymbol1++;
        }
        if (chosenSymbol == symbol2) {
            nrSymbol2++;
        }
    }
    assertThatUnsignedInt(nrSymbol1, greaterThan(@0));
    assertThatUnsignedInt(nrSymbol2, greaterThan(@0));
    assertThatUnsignedInt(nrSymbol1 + nrSymbol2, is(equalToUnsignedInt(nrTests)));
}

- (void)test_chooseOneSymbol_ShouldOnlySymbol_WhenOneSymbolInList {
    ConversationToken *onlyToken = [FHConfirmation new];
    NSArray *symbols = @[[self tagAndTokenFor:onlyToken]];

    id chosenSymbol = [_randomizer chooseOneToken:symbols];
    assertThat(chosenSymbol, is(equalTo(onlyToken)));
}

- (void)test_chooseOneSymbol_ShouldThrowException_WhenListIsEmpty {
    assertThat(^() {
        [_randomizer chooseOneToken:[NSArray new]];
    }, throwsExceptionOfType(DesignByContractException.class));
}

- (void)test_doOptional_ShouldCallActionOnARandomBasis {
    __block NSUInteger nrCalls = 0;
    void (^block)() = ^() {
        nrCalls++;
    };

    NSUInteger nrTests = 20;
    for (NSUInteger i = 0; i < nrTests; i++) {
        [_randomizer doOptionally:@"Tag" byCalling:block];
    }

    assertThatUnsignedInt(nrCalls, greaterThan(@0));
    assertThatUnsignedInt(nrCalls, lessThan(@(nrTests)));
}

- (void)test_chooseOneText_ShouldThrowException_WhenListIsEmpty {
    assertThat(^() {
        [_randomizer chooseOneTextFrom:@[]];
    }, throwsExceptionOfType(DesignByContractException.class));
}

- (void)test_chooseOneText_ShouldChooseATextRandomly {
    NSString *text1 = @"Hello";
    NSString *text2 = @"Bye";
    NSArray *texts = @[text1, text2];

    NSUInteger nrTests = 10;
    NSUInteger nrText1 = 0;
    NSUInteger nrText2 = 0;
    for (NSUInteger i = 0; i < nrTests; i++) {
        id chosenText = [_randomizer chooseOneTextFrom:texts];;
        assertThat(chosenText, is(notNilValue()));
        if (chosenText == text1) {
            nrText1++;
        }
        if (chosenText == text2) {
            nrText2++;
        }
    }
    assertThatUnsignedInt(nrText1, greaterThan(@0));
    assertThatUnsignedInt(nrText2, greaterThan(@0));
    assertThatUnsignedInt(nrText1 + nrText2, is(equalToUnsignedInt(nrTests)));
}

@end
