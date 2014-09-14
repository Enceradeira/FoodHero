//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TextRepositoryStub.h"


@implementation TextRepositoryStub {

    NSString *_greeting;
}
- (NSString *)getGreeting {
    return _greeting == nil ? @"Hello" : _greeting;
}

- (NSString *)getFemaleCelebrity {
    return @"Angelina Jolie";
}

- (NSString *)getMaleCelebrity {
    return @"Johnny Depp";
}

- (NSString *)getPlace {
    return @"Norwich";
}

- (NSString *)getSuggestion {
    return @"This is a no brainer.  You should try %@.";
}

- (NSString *)getCelebrity {
    return [self getMaleCelebrity];
}

- (NSString *)getSuggestionWithConfirmationIfInNewPreferredRangeCheaper {
    return @"If you like it cheaper, the %@ could be your choice";
}

- (NSString *)getGoodByeAfterSuccess {
    return @"Behave yourself, now.";
}

- (NSString *)getCommentChoice {
    return @"Yes!  I got you to do it!";
}

- (NSString *)getWhatToDoNextComment {
    return @"Anything else?";
}

- (NSString *)getOpeningQuestion {
    return @"What kind of food would you like to eat?";
}

- (void)injectGreeting:(NSString *)greeting {
    _greeting = greeting;
}
@end