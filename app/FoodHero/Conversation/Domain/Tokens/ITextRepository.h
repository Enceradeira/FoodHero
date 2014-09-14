//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITextRepository <NSObject>
- (NSString *)getGreeting;

- (NSString *)getFemaleCelebrity;

- (NSString *)getMaleCelebrity;

- (NSString *)getPlace;

- (NSString *)getSuggestion;

- (NSString *)getCelebrity;

- (NSString *)getSuggestionWithConfirmationIfInNewPreferredRangeCheaper;

- (NSString *)getGoodByeAfterSuccess;

- (NSString *)getCommentChoice;

- (NSString *)getWhatToDoNextComment;

- (NSString *)getOpeningQuestion;
@end