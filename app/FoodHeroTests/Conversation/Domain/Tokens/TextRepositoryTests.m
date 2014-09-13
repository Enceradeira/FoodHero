//
//  TextRepositoryTests.m
//  FoodHero
//
//  Created by Jorg on 13/09/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "TextRepository.h"
#import "NoRepetionForContextRandomizer.h"

@interface TextRepositoryTests : XCTestCase

@end

@implementation TextRepositoryTests {
    TextRepository *_repository;
    NoRepetionForContextRandomizer *_randomizer;
}


- (void)setUp {
    [super setUp];

    _randomizer = [NoRepetionForContextRandomizer new];
    _repository = [[TextRepository alloc] initWithRandomizer:_randomizer];
}

- (void)assertCorrectTextsFor:(NSString *(^)())textFactory context:(NSString const *)context {
    [_randomizer configureContext:context];
    do {
        NSString *text = textFactory();
        //NSLog(text);
        assertThat(text, is(notNilValue()));
        assertThatInteger(text.length, is(greaterThan(@(0))));
        // check that all substitutions have take place
        assertThat(text, isNot(containsString(@"%")));
        assertThat(text, isNot(containsString(@"@")));
    } while ([_randomizer hasMoreForContext]);
}


- (void)assertCorrectTextsWithPlaceholderFor:(NSString *(^)())textFactory context:(NSString const *)context {
    [_randomizer configureContext:context];
    do {
        NSString *text = textFactory();
        //NSLog(text,"King's Head");
        assertThat(text, is(notNilValue()));
        assertThatInteger(text.length, is(greaterThan(@(0))));
        // check that one placeholder for the restaurant is in the string
        NSUInteger nrPlaceholders = [[text componentsSeparatedByString:@"%@"] count] - 1;
        assertThatInteger(nrPlaceholders, is(equalTo(@(1))));
    } while ([_randomizer hasMoreForContext]);
}

- (void)test_getGreeting_ShouldReturnTextForAllVariations {
    [self assertCorrectTextsFor:^() {
        return [_repository getGreeting];
    }                   context:ContextGreeting];
}

- (void)test_getFemaleCelebrity_ShouldReturnTextForAllVariations {
    [self assertCorrectTextsFor:^() {
        return [_repository getFemaleCelebrity];
    }                   context:ContextFemaleCelebrity];
}

- (void)test_getMaleCelebrity_ShouldReturnTextForAllVariations {
    [self assertCorrectTextsFor:^() {
        return [_repository getMaleCelebrity];
    }                   context:ContextMaleCelebrity];
}

- (void)test_getPlace_ShouldReturnTextForAllVariations {
    [self assertCorrectTextsFor:^() {
        return [_repository getPlace];
    }                   context:ContextPlace];
}

- (void)test_getSuggestion_ShouldReturnTextForAllVariations {

    [self assertCorrectTextsWithPlaceholderFor:^() {
        return _repository.getSuggestion;
    }                                  context:ContextSuggestion];
}


- (void)test_getSuggestionWithConfirmationIfInNewPreferredRangeCheaper_ShouldReturnTexts {
    [self assertCorrectTextsWithPlaceholderFor:^() {
        return _repository.getSuggestionWithConfirmationIfInNewPreferredRangeCheaper;
    }                                  context:ContextSuggestionWithConfirmationIfInNewPreferredRangeCheaper];
}

- (void)test_getCelebrity_ShouldReturnTextForAllVariations {
    [self assertCorrectTextsFor:^() {
        return [_repository getCelebrity];
    }                   context:@"Celebrity"];
}


@end
