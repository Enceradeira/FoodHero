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

- (void)assertCorrectTextsFor:(TextAndSound *(^)())textFactory context:(NSString const *)context {
    [_randomizer configureContext:context];
    do {
        TextAndSound *text = textFactory();
        // NSLog(text.text);
        assertThat(text, is(notNilValue()));
        assertThatInteger(text.text.length, is(greaterThan(@(0))));
        // check that all substitutions have take place
        assertThat(text, isNot(containsString(@"%")));
        assertThat(text, isNot(containsString(@"@")));
    } while ([_randomizer hasMoreForContext]);
}


- (void)assertCorrectTextsWithPlaceholderFor:(TextAndSound *(^)())textFactory context:(NSString const *)context {
    [_randomizer configureContext:context];
    do {
        TextAndSound *text = textFactory();
        //NSLog(text,"King's Head");
        assertThat(text, is(notNilValue()));
        assertThatInteger(text.text.length, is(greaterThan(@(0))));
        // check that one placeholder for the restaurant is in the string
        NSUInteger nrPlaceholders = [[text.text componentsSeparatedByString:@"%@"] count] - 1;
        assertThatInteger(nrPlaceholders, is(equalTo(@(1))));
    } while ([_randomizer hasMoreForContext]);
}

- (void)test_getGreeting_ShouldReturnTexts {
    [self assertCorrectTextsFor:^() {
        return [_repository getGreeting];
    }                   context:ContextGreeting];
}

- (void)test_getOpeningQuestion_ShouldReturnTexts {
    [self assertCorrectTextsFor:^() {
        return [_repository getOpeningQuestion];
    }                   context:ContextOpeningQuestion];
}

- (void)test_getFemaleCelebrity_ShouldReturnTexts {
    [self assertCorrectTextsFor:^() {
        return [_repository getFemaleCelebrity];
    }                   context:ContextFemaleCelebrity];
}

- (void)test_getMaleCelebrity_ShouldReturnTexts {
    [self assertCorrectTextsFor:^() {
        return [_repository getMaleCelebrity];
    }                   context:ContextMaleCelebrity];
}

- (void)test_getPlace_ShouldReturnTexts {
    [self assertCorrectTextsFor:^() {
        return [_repository getPlace];
    }                   context:ContextPlace];
}

- (void)test_getSuggestion_ShouldReturnTexts {

    [self assertCorrectTextsWithPlaceholderFor:^() {
        return _repository.getSuggestion;
    }                                  context:ContextSuggestion];
}

- (void)test_getCommentChoice_ShouldReturnTexts {
    [self assertCorrectTextsFor:^() {
        return [_repository getCommentChoice];
    }                   context:ContextCommentChoice];
}

- (void)test_getWhatToDoNextComment_ShouldReturnTexts {

    [self assertCorrectTextsFor:^() {
        return _repository.getWhatToDoNextComment;
    }                   context:ContextWhatToDoNextComment];
}


- (void)test_getSuggestionWithConfirmationIfInNewPreferredRangeCheaper_ShouldReturnTexts {
    [self assertCorrectTextsWithPlaceholderFor:^() {
        return _repository.getSuggestionWithConfirmationIfInNewPreferredRangeCheaper;
    }                                  context:ContextSuggestionWithConfirmationIfInNewPreferredRangeCheaper];
}

- (void)test_getCelebrity_ShouldReturnTexts {
    [self assertCorrectTextsFor:^() {
        return [_repository getCelebrity];
    }                   context:ContextCelebrity];
}

- (void)test_getGoodByeAfterSuccess_ShouldReturnTexts {
    [self assertCorrectTextsFor:^() {
        return [_repository getGoodByeAfterSuccess];
    }                   context:ContextGoodByeAfterSuccess];
}

- (void)test_getFood_ShouldReturnTexts {
    [self assertCorrectTextsFor:^() {
        return [_repository getFood];
    }                   context:ContextFood];
}



@end
