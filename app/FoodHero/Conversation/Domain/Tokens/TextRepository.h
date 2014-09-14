//
// Created by Jorg on 13/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Randomizer.h"
#import "ITextRepository.h"

extern const NSString *ContextFemaleCelebrity;
extern const NSString *ContextCommentChoice;
extern const NSString *ContextWhatToDoNextComment;
extern const NSString *ContextGoodByeAfterSuccess;
extern const NSString *ContextMaleCelebrity;
extern const NSString *ContextGreeting;
extern const NSString *ContextPlace;
extern const NSString *ContextSuggestion;
extern const NSString *ContextOpeningQuestion;
extern const NSString *ContextCelebrity;
extern const NSString *ContextSuggestionWithConfirmationIfInNewPreferredRangeCheaper;

@interface TextRepository : NSObject <ITextRepository>

- (instancetype)initWithRandomizer:(id <Randomizer>)randomizer;

@end