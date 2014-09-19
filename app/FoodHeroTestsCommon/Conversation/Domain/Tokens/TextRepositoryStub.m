//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TextRepositoryStub.h"

TextAndSound *t(NSString *text) {
    return [TextAndSound create:text];
}

TextAndSound *ts(NSString *text, Sound *sound) {
    return [TextAndSound create:text sound:sound];
}

@implementation TextRepositoryStub {

    TextAndSound *_greeting;
}
- (TextAndSound *)getGreeting {
    return _greeting == nil ? t(@"Hello") : _greeting;
}

- (TextAndSound *)getFemaleCelebrity {
    return t(@"Angelina Jolie");
}

- (TextAndSound *)getMaleCelebrity {
    return t(@"Johnny Depp");
}

- (TextAndSound *)getPlace {
    return t(@"Norwich");
}

- (TextAndSound *)getSuggestion {
    return t(@"This is a no brainer.  You should try %@.");
}

- (TextAndSound *)getCelebrity {
    return [self getMaleCelebrity];
}

- (TextAndSound *)getSuggestionWithConfirmationIfInNewPreferredRangeCheaper {
    return t(@"If you like it cheaper, the %@ could be your choice");
}

- (TextAndSound *)getGoodByeAfterSuccess {
    return t(@"Behave yourself, now.");
}

- (TextAndSound *)getCommentChoice {
    return t(@"Yes!  I got you to do it!");
}

- (TextAndSound *)getWhatToDoNextComment {
    return t(@"Anything else?");
}

- (TextAndSound *)getOpeningQuestion {
    return t(@"What kind of food would you like to eat?");
}

- (void)injectGreeting:(TextAndSound *)greeting {
    _greeting = greeting;
}
@end