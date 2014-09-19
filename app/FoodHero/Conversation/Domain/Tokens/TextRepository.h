//
// Created by Jorg on 13/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Randomizer.h"
#import "ITextRepository.h"

extern NSString *const ContextFemaleCelebrity;
extern NSString *const ContextCommentChoice;
extern NSString *const ContextWhatToDoNextComment;
extern NSString *const ContextGoodByeAfterSuccess;
extern NSString *const ContextMaleCelebrity;
extern NSString *const ContextGreeting;
extern NSString *const ContextPlace;
extern NSString *const ContextSuggestion;
extern NSString *const ContextOpeningQuestion;
extern NSString *const ContextCelebrity;
extern NSString *const ContextFood;
extern NSString *const ContextSuggestionWithConfirmationIfInNewPreferredRangeCheaper;

@interface TextRepository : NSObject <ITextRepository>

- (instancetype)initWithRandomizer:(id <Randomizer>)randomizer;

- (TextAndSound *)getFood;
@end