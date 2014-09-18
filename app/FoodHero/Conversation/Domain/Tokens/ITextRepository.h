//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextAndSound.h"

@protocol ITextRepository <NSObject>
- (TextAndSound *)getGreeting;

- (TextAndSound *)getFemaleCelebrity;

- (TextAndSound *)getMaleCelebrity;

- (TextAndSound *)getPlace;

- (TextAndSound *)getSuggestion;

- (TextAndSound *)getCelebrity;

- (TextAndSound *)getSuggestionWithConfirmationIfInNewPreferredRangeCheaper;

- (TextAndSound *)getGoodByeAfterSuccess;

- (TextAndSound *)getCommentChoice;

- (TextAndSound *)getWhatToDoNextComment;

- (TextAndSound *)getOpeningQuestion;
@end